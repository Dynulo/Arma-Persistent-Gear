pub fn internal_save(player: u64, reason: String, amount: i32) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .post(&format!("{}/v2/bank/transactions/{}", *crate::HOST, player))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&crate::models::Transaction { reason, amount })
        .send()
    {
        Ok(_) => Ok(()),
        Err(e) => Err(e.to_string()),
    }
}
