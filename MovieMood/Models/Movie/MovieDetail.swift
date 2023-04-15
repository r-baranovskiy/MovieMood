struct MovieDetail: Decodable {
    let backdrop_path: String?
    let genres: [Genre]
    let title: String
    let vote_average: Double
    let vote_count: Int
    let runtime: Int?
    let release_date: String
    let poster_path: String?
    let overview: String?
    let id: Int
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
