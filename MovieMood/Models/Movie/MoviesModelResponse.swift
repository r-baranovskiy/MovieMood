struct Movie: Decodable {
    let results: [MovieModel]
}

struct MovieModel: Decodable {
    let id: Int
    let title: String
    let release_date: String
    let genre_ids: [Int]
    let poster_path: String?
}
