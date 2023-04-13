struct TV: Codable {
    let results: [TVModel]
}

struct TVModel: Codable {
    let id: Int
}
