use std::sync::RwLock;

use arma_rs::{rv, rv_handler};

#[macro_use]
extern crate arma_rs_macros;

#[macro_use]
extern crate lazy_static;

#[macro_use]
extern crate serde;

lazy_static! {
    static ref HOST: String =
        std::env::var("DYNULO_PMC_HOST").unwrap_or_else(|_| "http://localhost:8000".to_string());
    static ref TOKEN: RwLock<String> = RwLock::new(String::new());
}

mod items;
mod loadouts;
mod models;
mod traits;
mod purchases;
mod transactions;
mod variables;

#[rv_handler]
const fn init() {}

#[rv]
fn setup(token: String) -> bool {
    if token.is_empty() {
        false
    } else {
        *TOKEN.write().unwrap() = token;
        true
    }
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
            format!("[{}, {}]", loadout.player, loadout.loadout)
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
        rv_callback!("dynulo_pmc", "variables", variables);
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
            v.push(format!("\"\"{}\"\"", trait_.trait_));
        }
        rv_callback!("dynulo_pmc", "traits", format!("[{}]", v.join(",")));
    }
}

#[rv(thread = true)]
fn save_trait(player: u64, trait_: String) {
    traits::internal_save(player, trait_);
}

#[rv(thread = true)]
fn delete_trait(player: u64, trait_: String) {
    traits::internal_delete(player, trait_);
}

// Items

// #[rv(thread = true)]
// fn get_items() {
//     if let Some(items) = items::internal_get() {
//         let mut v = Vec::new();
//         for item in items {
//             v.push(format!("\"\"{}\"\"", item));
//         }
//         rv_callback!("dynulo_pmc", "traits", format!("[{}]", v.join(",")));
//     }
// }
