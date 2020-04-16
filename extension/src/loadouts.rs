use std::collections::HashMap;

// TODO log errors
pub fn internal_get(player: u64) -> Option<crate::models::Loadout> {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return None;
    }
    if let Ok(s) = reqwest::blocking::Client::new()
        .get(&format!("{}/v1/players/{}/loadout", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<crate::models::Loadout>()
    {
        Some(s)
    } else {
        None
    }
}

// TODO log errors
pub fn internal_save(player: u64, loadout: String) {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return;
    }
    let mut map = HashMap::new();
    map.insert("loadout", loadout);
    reqwest::blocking::Client::new()
        .post(&format!("{}/v1/players/{}/loadout", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&map)
        .send();
}

#[test]
fn test_loadouts() {
    use rand::Rng;
    crate::setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
    let rand_string: String = rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(30)
        .collect();
    internal_save(123_456_789, rand_string.clone());
    let loadout = internal_get(123_456_789).unwrap();
    assert_eq!(loadout.loadout, rand_string);
}
