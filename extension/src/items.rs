pub fn internal_get() -> Result<Vec<crate::models::Item>, String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .get(&format!("{}/v2/items", *crate::HOST))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<Vec<crate::models::Item>>()
    {
        Ok(s) => Ok(s),
        Err(e) => Err(e.to_string()),
    }
}

#[test]
fn test_items() {
    crate::setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
    let items = internal_get().unwrap();
    assert_eq!(items[0].class, "prince");
    assert_eq!(items[0].cost, 1);
}
