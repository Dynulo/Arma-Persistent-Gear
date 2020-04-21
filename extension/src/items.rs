// TODO log errors
pub fn internal_get() -> Option<Vec<crate::models::Item>> {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return None;
    }
    if let Ok(s) = reqwest::blocking::Client::new()
        .get(&format!("{}/v1/items/", *crate::HOST))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<Vec<crate::models::Item>>()
    {
        Some(s)
    } else {
        None
    }
}

#[test]
fn test_items() {
    crate::setup("d1d76da3-d759-4637-83d3-c5084c0b99ce".to_string());
    let items = internal_get().unwrap();
    assert_eq!(items[0].class, "prince");
    assert_eq!(items[0].cost, 1);
}
