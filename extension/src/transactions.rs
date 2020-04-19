// TODO log errors
pub fn internal_save(player: u64, reason: String, amount: i32) {
    if crate::TOKEN.read().unwrap().is_empty() {
        println!("Empty token");
        return;
    }
    reqwest::blocking::Client::new()
        .post(&format!(
            "{}/v1/players/{}/transaction",
            *crate::HOST,
            player
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&crate::models::Transaction { reason, amount })
        .send()
        .unwrap();
}
