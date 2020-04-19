use std::collections::HashMap;

lazy_static! {
    static ref RE: regex::Regex =
        regex::Regex::new(r"(?m)\[([^\[,]+?),\s?([^\[,]+?),\s?([^\[,]+?)\]").unwrap();
}

// TODO log errors
pub fn internal_save(player: u64, class: String, amount: i32, quantity: i32) {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return;
    }
    let mut purchases = Vec::new();
    purchases.push(crate::models::Purchase {
        class,
        amount,
        quantity,
    });
    let mut map = HashMap::new();
    map.insert("purcahses", purchases);
    reqwest::blocking::Client::new()
        .post(&format!("{}/v1/players/{}/purchases", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&map)
        .send()
        .unwrap();
}
