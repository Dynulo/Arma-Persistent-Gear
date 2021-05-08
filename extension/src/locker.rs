use std::str::FromStr;

lazy_static! {
    static ref RE: regex::Regex = regex::Regex::new(r#"(?m)\[([^\[,]+?),\s?([^\[,]+?)\]"#).unwrap();
}

pub fn internal_get(player: u64) -> Result<Vec<crate::models::Locker>, String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .get(&format!("{}/v2/players/{}/locker", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<Vec<crate::models::Locker>>()
    {
        Ok(s) => Ok(s),
        Err(e) => Err(e.to_string()),
    }
}

pub fn internal_take(player: u64, array: String) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    let array = array.replace("\"\"", "\"").replace("\"\"", "\"");
    let mut items = Vec::new();
    for mat in RE.captures_iter(&array) {
        items.push(crate::models::Locker {
            class: mat.get(1).unwrap().as_str().replace("\"", ""),
            quantity: FromStr::from_str(mat.get(2).unwrap().as_str()).unwrap(),
        });
    }
    match reqwest::blocking::Client::new()
        .post(&format!(
            "{}/v2/players/{}/locker/take",
            *crate::HOST,
            player
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&items)
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

pub fn internal_store(player: u64, array: String) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    let array = array.replace("\"\"", "\"").replace("\"\"", "\"");
    let mut items = Vec::new();
    for mat in RE.captures_iter(&array) {
        items.push(crate::models::Locker {
            class: mat.get(1).unwrap().as_str().replace("\"", ""),
            quantity: FromStr::from_str(mat.get(2).unwrap().as_str()).unwrap(),
        });
    }
    match reqwest::blocking::Client::new()
        .post(&format!(
            "{}/v2/players/{}/locker/store",
            *crate::HOST,
            player
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&items)
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
