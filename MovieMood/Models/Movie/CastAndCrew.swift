struct CastAndCrew: Decodable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Decodable {
    let name: String
    let character: String
    let profile_path: String?
}

struct Crew: Decodable {
    let name: String
    let department: String
    let profile_path: String?
}
