use std::sync::RwLock;

use arma_rs::{rv, rv_callback, rv_handler};

#[macro_use]
extern crate log;

#[macro_use]
extern crate lazy_static;

#[macro_use]
extern crate serde;

lazy_static! {
    static ref HOST: String = std::env::var("DYNULO_PMC_HOST")
        .unwrap_or_else(|_| "https://dev.dynulo.com/pmc".to_string());
    static ref TOKEN: RwLock<String> = RwLock::new(String::new());
}

mod models;

mod items;
mod loadouts;
mod locker;
mod players;
mod purchases;
mod transactions;
mod variables;

#[rv]
fn setup(token: String) -> bool {
    if token.is_empty() {
        false
    } else {
        *TOKEN.write().unwrap() = token;
        true
    }
}

#[rv]
#[allow(unused_must_use)]
fn browser(url: String) -> String {
    webbrowser::open(&url);
    url
}

#[test]
fn test_setup() {
    setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
}

// Loadouts

#[rv(thread = true)]
fn get_loadout(player: u64) {
    match loadouts::internal_get(player) {
        Ok(loadout) => rv_callback!(
            "dynulo_pmc",
            "loadout",
            loadout.player.to_string(),
            loadout.loadout
        ),
        Err(e) => error!("Error fetching loadout: {}", e),
    }
}

#[rv(thread = true)]
fn save_loadout(player: u64, loadout: String) {
    if let Err(e) = loadouts::internal_save(player, loadout) {
        error!("Error setting loadout: {}", e);
    }
}

// Purchases

#[rv(thread = true)]
fn purchase(player: u64, array: String) {
    match purchases::internal_save(player, array.clone()) {
        Ok(_) => {
            locker_get(player);
            rv_callback!("dynulo_pmc", "purchase_success", player.to_string())
        },
        Err(e) => {
            rv_callback!("dynulo_pmc", "purchase_failed", player.to_string());
            error!("Error creating purchase: {}", e);
        }
    }
}

// Transactions

#[rv(thread = true)]
fn transaction(player: u64, reason: String, amount: i32) {
    match transactions::internal_save(player, reason, amount) {
        Ok(_) => rv_callback!("dynulo_pmc", "transaction_success", player.to_string()),
        Err(e) => {
            rv_callback!("dynulo_pmc", "transaction_failed", player.to_string());
            error!("Error creating transaction: {}", e);
        }
    }
}

// Locker

#[rv(thread = true)]
fn locker_get(player: u64) {
    match locker::internal_get(player) {
        Ok(items) => {
            rv_callback!("dynulo_pmc", "locker_new", player.to_string());
            info!("Found {} items", items.len());
            for item in items {
                rv_callback!(
                    "dynulo_pmc",
                    "locker_item",
                    player.to_string(),
                    item.class,
                    item.quantity
                );
            }
            rv_callback!("dynulo_pmc", "locker_publish", player.to_string());
        }
        Err(e) => error!("error fetching locker: {}", e),
    }
}

#[rv(thread = true)]
fn locker_take(player: u64, array: String) {
    match locker::internal_take(player, array) {
        Ok(_) => rv_callback!("dynulo_pmc", "locker_take_success", player.to_string()),
        Err(e) => {
            rv_callback!("dynulo_pmc", "locker_take_failed", player.to_string());
            error!("Error creating purchase: {}", e);
        }
    }
}

#[rv(thread = true)]
fn locker_store(player: u64, array: String) {
    match locker::internal_store(player, array) {
        Ok(_) => rv_callback!("dynulo_pmc", "locker_store_success", player.to_string()),
        Err(e) => {
            rv_callback!("dynulo_pmc", "locker_store_failed", player.to_string());
            error!("Error creating purchase: {}", e);
        }
    }
}

// Variables

#[rv(thread = true)]
fn get_variables(player: u64) {
    match variables::internal_get(player) {
        Ok(variables) => {
            for (k, v) in variables {
                rv_callback!("dynulo_pmc", "variable", player.to_string(), k, v);
            }
        }
        Err(e) => error!("Error fetching variables: {}", e),
    }
}

#[rv(thread = true)]
fn save_variable(player: u64, key: String, value: String) {
    if let Err(e) = variables::internal_save(player, &key, &value) {
        error!("Error creating transaction: {}", e);
    }
}

// Items

#[rv(thread = true)]
fn get_items() {
    match items::internal_get() {
        Ok(items) => {
            rv_callback!("dynulo_pmc", "items_clear", "");
            info!("Found {} items", items.len());
            for item in items {
                let mut traits = Vec::new();
                for trait_ in item.traits.split('|') {
                    traits.push(trait_.to_string());
                }
                rv_callback!("dynulo_pmc", "item", item.class, item.cost, traits, item.global as i32);
            }
            rv_callback!("dynulo_pmc", "items_publish", "");
        }
        Err(e) => error!("error fetching items: {}", e),
    }
}

// Players

#[rv(thread = true)]
fn set_nickname(player: u64, nickname: String) {
    if let Err(e) = players::internal_save(player, nickname) {
        error!("Error setting nickname: {}", e);
    }
}

#[rv(thread = true)]
fn balance_get(player: u64) {
    match players::internal_get_balance(player) {
        Ok(balance) => {
            rv_callback!("dynulo_pmc", "balance_success", player.to_string(), balance);
        }
        Err(e) => {
            rv_callback!("dynulo_pmc", "balance_failed", player.to_string());
            error!("Error fetching balance: {}", e);
        }
    }
}

use log::{Level, LevelFilter, Metadata, Record};
struct ArmaLogger;

impl log::Log for ArmaLogger {
    fn enabled(&self, metadata: &Metadata) -> bool {
        metadata.level() <= Level::Info
    }

    fn log(&self, record: &Record) {
        if self.enabled(record.metadata()) {
            rv_callback!(
                "dynulo_pmc_log",
                format!("{}", record.level()).to_uppercase(),
                format!("{}", record.args())
            );
        }
    }

    fn flush(&self) {}
}
static LOGGER: ArmaLogger = ArmaLogger;

#[rv_handler]
fn init() {
    log::set_logger(&LOGGER).map(|()| log::set_max_level(LevelFilter::Info));
}
