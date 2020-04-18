#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct Item {
    pub guild: String,
    pub class: String,
    pub pretty: String,
    pub cost: i32,
    pub traits: String,
}
