#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Locker {
    pub class: String,
    pub quantity: i32,
}
