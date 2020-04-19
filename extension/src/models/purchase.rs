#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Purchase {
    pub amount: i32,
    pub quantity: i32,
    pub class: String,
}
