use std::collections::HashMap;

lazy_static! {
    static ref RE: regex::Regex = regex::Regex::new(r"(?m)\[([^\[]+?),\s?([^\[]+?)\]").unwrap();
}

// TODO log errors
pub fn internal_get(player: u64) -> Option<Vec<(String, String)>> {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return None;
    }
    if let Ok(s) = reqwest::blocking::Client::new()
        .get(&format!("{}/v1/players/{}/variables", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<crate::models::Variables>()
    {
        let crate::models::Variables(vars) = s;
        let mut v = Vec::new();
        for var in vars {
            v.push((var.vkey, var.vvalue));
        }
        Some(v)
    } else {
        None
    }
}

// TODO log errors
pub fn internal_save(player: u64, array: &str) {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return;
    }
    let mut variables: HashMap<String, String> = HashMap::new();
    for mat in RE.captures_iter(array) {
        info!(
            "Saving variable for {}: {} = {}",
            player,
            mat.get(1).unwrap().as_str(),
            mat.get(2).unwrap().as_str()
        );
        variables.insert(
            mat.get(1)
                .unwrap()
                .as_str()
                .trim_start_matches("\"\"")
                .trim_end_matches("\"\"")
                .to_string(),
            mat.get(2)
                .unwrap()
                .as_str()
                .trim_start_matches("\"\"")
                .trim_end_matches("\"\"")
                .to_string(),
        );
    }
    let mut map = HashMap::new();
    map.insert("variables", variables);
    reqwest::blocking::Client::new()
        .post(&format!("{}/v1/players/{}/variables", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&map)
        .send()
        .unwrap();
}

#[test]
fn test_variables() {
    use rand::Rng;
    crate::setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
    let rand_string: String = rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(30)
        .collect();
    let save = format!("[[\"\"test\"\",\"\"{}\"\"]]", rand_string);
    internal_save(123_456_789, &save);
    if let Some(variables) = internal_get(123_456_789) {
        assert_eq!(variables, vec![("test".to_string(), rand_string)]);
    } else {
        panic!();
    }
}
