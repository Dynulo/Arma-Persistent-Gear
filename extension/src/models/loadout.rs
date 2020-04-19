#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Loadout {
    pub guild: String,
    pub player: u64,
    pub loadout: String,
}
