use std::sync::RwLock;

use arma_rs::{rv, rv_callback, rv_handler};

#[macro_use]
extern crate log;

#[macro_use]
extern crate lazy_static;

#[macro_use]
extern crate serde;

lazy_static! {
    static ref HOST: String =
        std::env::var("DYNULO_PMC_HOST").unwrap_or_else(|_| "https://pmc.dynulo.com".to_string());
    static ref TOKEN: RwLock<String> = RwLock::new(String::new());
}

mod models;

mod items;
mod loadouts;
mod players;
mod purchases;
mod traits;
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
    if let Some(loadout) = loadouts::internal_get(player) {
        rv_callback!(
            "dynulo_pmc",
            "loadout",
            loadout.player.to_string(),
            loadout.loadout
        );
    }
}

#[rv(thread = true)]
fn save_loadout(player: u64, loadout: String) {
    loadouts::internal_save(player, loadout);
}

// Purchases

#[rv(thread = true)]
fn purchase(player: u64, class: String, amount: i32, quantity: i32) {
    purchases::internal_save(player, class, amount, quantity)
}

// Transactions

#[rv(thread = true)]
fn transaction(player: u64, reason: String, amount: i32) {
    transactions::internal_save(player, reason, amount)
}

// Variables

#[rv(thread = true)]
fn get_variables(player: u64) {
    if let Some(variables) = variables::internal_get(player) {
        for (k, v) in variables {
            rv_callback!("dynulo_pmc", "variable", player.to_string(), k, v);
        }
    }
}

#[rv(thread = true)]
fn save_variables(player: u64, vars: String) {
    variables::internal_save(player, &vars);
}

// Traits

#[rv(thread = true)]
fn get_traits(player: u64) {
    if let Some(traits) = traits::internal_get(player) {
        let mut v = Vec::new();
        for trait_ in traits {
            v.push(trait_.trait_);
        }
        rv_callback!("dynulo_pmc", "traits", player, v);
    }
}

#[rv(thread = true)]
fn save_trait(player: u64, trait_: String) {
    traits::internal_save(player, &trait_);
}

#[rv(thread = true)]
fn delete_trait(player: u64, trait_: String) {
    traits::internal_delete(player, trait_);
}

// Items

#[rv(thread = true)]
fn get_items() {
    if let Some(items) = items::internal_get() {
        rv_callback!("dynulo_pmc", "clear_items", "");
        info!("Found {} items", items.len());
        for item in items {
            let mut traits = Vec::new();
            for trait_ in item.traits.split('|') {
                traits.push(trait_.to_string());
            }
            rv_callback!("dynulo_pmc", "item", item.class, item.cost, traits);
        }
        rv_callback!("dynulo_pmc", "publish_items", "");
    }
}

// Players

#[rv(thread = true)]
fn set_nickname(player: u64, nickname: String) {
    players::internal_save(player, nickname);
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
                format!("{}", record.level()).to_lowercase(),
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
