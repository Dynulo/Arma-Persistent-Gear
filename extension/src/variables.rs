pub fn internal_get(player: u64) -> Result<Vec<(String, String)>, String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .get(&format!("{}/v2/players/{}/variables", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<crate::models::Variables>()
    {
        Ok(s) => {
            let crate::models::Variables(vars) = s;
            let mut v = Vec::new();
            for var in vars {
                v.push((var.vkey, var.vvalue));
            }
            Ok(v)
        }
        Err(e) => Err(e.to_string()),
    }
}

pub fn internal_save(player: u64, key: &str, value: &str) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .post(&format!(
            "{}/v2/players/{}/variables/{}",
            *crate::HOST,
            player,
            key
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .body(
            value
                .trim_start_matches("\"\"")
                .trim_end_matches("\"\"")
                .to_string(),
        )
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
fn test_variables() {
    use rand::Rng;
    crate::setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
    let rand_string: String = rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(30)
        .collect();
    internal_save(123_456_789, "test", &rand_string).unwrap();
    let variables = internal_get(123_456_789).unwrap();
    assert_eq!(variables, vec![("test".to_string(), rand_string)]);
}
