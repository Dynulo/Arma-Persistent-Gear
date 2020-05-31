// TODO log errors
pub fn internal_get(player: u64) -> Option<Vec<crate::models::Trait>> {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return None;
    }
    if let Ok(s) = reqwest::blocking::Client::new()
        .get(&format!("{}/v1/players/{}/traits", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<Vec<crate::models::Trait>>()
    {
        Some(s)
    } else {
        None
    }
}

// TODO log errors
pub fn internal_save(player: u64, trait_name: &str) {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return;
    }
    reqwest::blocking::Client::new()
        .post(&format!(
            "{}/v1/players/{}/traits/{}",
            *crate::HOST,
            player,
            trait_name
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send();
}

pub fn internal_delete(player: u64, trait_name: String) {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return;
    }
    reqwest::blocking::Client::new()
        .delete(&format!(
            "{}/v1/players/{}/traits/{}",
            *crate::HOST,
            player,
            trait_name
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send();
}

#[test]
fn test_traits() {
    use rand::Rng;
    crate::setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
    let rand_string: String = rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(30)
        .collect();
    internal_save(123_456_789, &rand_string);
    let all_traits = internal_get(123_456_789).unwrap();
    assert_eq!(all_traits[0].trait_, rand_string);
    internal_delete(123_456_789, rand_string)
}
