use std::collections::HashMap;

// TODO log errors
pub fn internal_save(player: u64, nickname: String) {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return;
    }
    let mut map = HashMap::new();
    map.insert("nickname", nickname);
    reqwest::blocking::Client::new()
        .post(&format!("{}/v1/players/{}/nickname", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&map)
        .send()
        .unwrap();
}
