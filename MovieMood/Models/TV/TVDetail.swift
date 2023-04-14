import Foundation

struct TVDetail: Decodable {
    let firstAirDate: String
    let id: Int
    let lastAirDate: String
    let name: String
    let numberOfEpisodes, numberOfSeasons: Int
    let overview: String
    let popularity: Double
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int
    let genres: [TVGenre]

    enum CodingKeys: String, CodingKey {
        case firstAirDate = "first_air_date"
        case id, name, popularity, genres, overview
        case lastAirDate = "last_air_date"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct TVGenre: Decodable {
    let name: String
}
