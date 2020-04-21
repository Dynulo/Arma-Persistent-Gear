#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Loadout {
    pub player: u64,
    pub loadout: String,
}
