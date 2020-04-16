#[derive(Debug, Deserialize)]
pub struct Variables(pub Vec<Variable>);

#[derive(Debug, Deserialize)]
pub struct Variable {
    pub vkey: String,
    pub vvalue: String,
}
