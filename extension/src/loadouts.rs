use std::collections::HashMap;

pub fn internal_get(player: u64) -> Result<crate::models::Loadout, String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .get(&format!("{}/v2/players/{}/loadout", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<crate::models::Loadout>()
    {
        Ok(s) => Ok(s),
        Err(e) => Err(e.to_string()),
    }
}

pub fn internal_save(player: u64, loadout: String) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    let mut map = HashMap::new();
    map.insert("loadout", loadout.replace("\"\"", "\""));
    match reqwest::blocking::Client::new()
        .post(&format!("{}/v2/players/{}/loadout", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&map)
        .send()
    {
        Ok(resp) => {
            if resp.status().is_success() {
                Ok(())
            } else {
                Err(resp.status().to_string())
            }
        },
        Err(e) => Err(e.to_string()),
    }
}

#[test]
fn test_loadouts() {
    use rand::Rng;
    crate::setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
    let rand_string: String = rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(30)
        .collect();
    internal_save(123_456_789, rand_string.clone()).unwrap();
    let loadout = internal_get(123_456_789).unwrap();
    assert_eq!(loadout.loadout, rand_string);
}
