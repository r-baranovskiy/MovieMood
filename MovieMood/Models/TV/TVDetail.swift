import Foundation

struct TVDetail: Decodable {
    let firstAirDate: String
    let id: Int
    let lastAirDate: String
    let name: String
    let numberOfEpisodes, numberOfSeasons: Int
    let popularity: Double
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case firstAirDate = "first_air_date"
        case id
        case lastAirDate = "last_air_date"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
