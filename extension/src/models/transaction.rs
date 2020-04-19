#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Transaction {
    pub amount: i32,
    pub reason: String,
}
