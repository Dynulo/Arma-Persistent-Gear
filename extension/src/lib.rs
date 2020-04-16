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
        std::env::var("DYNULO_PMC_HOST").unwrap_or_else(|_| "https://pmc.dynulo.com".to_string());
    static ref TOKEN: RwLock<String> = RwLock::new(String::new());
}

mod loadouts;
mod models;
mod variables;

#[rv_handler]
fn init() {}

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

// Variables

#[rv(thread = true)]
fn get_variables(player: u64) {
    if let Some(variables) = variables::internal_get(player) {
        rv_callback!("dynulo_pmc", "variables", variables);
    }
}

#[rv(thread = true)]
fn save_variables(player: u64, vars: String) {
    variables::internal_save(player, vars);
}
