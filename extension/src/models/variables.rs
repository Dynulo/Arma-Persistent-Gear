#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Variables(pub Vec<Variable>);

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Variable {
    pub vkey: String,
    pub vvalue: String,
}
