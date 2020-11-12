use std::str::FromStr;

lazy_static! {
    static ref RE: regex::Regex =
        regex::Regex::new(r#"(?m)\[([^\[,]+?),\s?([^\[,]+?),\s?([^\[,]+?)\]"#).unwrap();
}

pub fn internal_save(player: u64, array: String) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    let array = array.replace("\"\"", "\"").replace("\"\"", "\"");
    let mut purchases = Vec::new();
    for mat in RE.captures_iter(&array) {
        purchases.push(crate::models::Purchase {
            class: mat
                .get(1)
                .unwrap()
                .as_str()
                .replace("\"", ""),
            amount: FromStr::from_str(mat.get(2).unwrap().as_str()).unwrap(),
            quantity: FromStr::from_str(mat.get(3).unwrap().as_str()).unwrap(),
        });
    }
    match reqwest::blocking::Client::new()
        .post(&format!("{}/v2/players/{}/purchases", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&purchases)
        .send()
    {
        Ok(_) => Ok(()),
        Err(e) => Err(e.to_string()),
    }
}
