#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct Item {
    pub class: String,
    pub cost: i32,
    pub traits: String,
}
