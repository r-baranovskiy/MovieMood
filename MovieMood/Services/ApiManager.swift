import Foundation

protocol ApiManagerProtocol {
    func fetchMovies() async throws -> MoviesResponseModel
    func fetchMovieDetail(with movieId: Int) async throws -> MovieDetailResponse
}

final class ApiManager {
    private let networkManager: NetworkManagerProtocol
    
    init(
        networkManager: NetworkManagerProtocol
    ) {
        self.networkManager = networkManager
    }
}

extension ApiManager: ApiManagerProtocol {
    func fetchMovies() async throws -> MoviesResponseModel {
        let urlString = "https://api.themoviedb.org/4/discover/movie?sort_by=popularity.desc&api_key=\(APIKey.apiKey)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchMovieDetail(with movieId: Int) async throws -> MovieDetailResponse {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(APIKey.apiKey)"
        print(urlString)
        return try await networkManager.request(urlString: urlString)
    }
}
