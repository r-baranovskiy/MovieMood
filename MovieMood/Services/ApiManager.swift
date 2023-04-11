import Foundation

protocol ApiManagerProtocol {
    func fetchMovies() async throws -> Movie
    func fetchMovieDetail(with movieId: Int) async throws -> MovieDetail
    func fetchCastAndCrew(with movieId: Int) async throws -> CastAndCrew
    func fetchMovieVideo(with movieId: Int) async throws -> MovieVideoModel
    func fetchSearchMovies(with movieName: String) async throws -> Movie
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

    func fetchMovies() async throws -> Movie {
        let urlString = "https://api.themoviedb.org/4/discover/movie?sort_by=popularity.desc&api_key=\(APIKey.apiKey)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchMovieDetail(with movieId: Int) async throws -> MovieDetail {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(APIKey.apiKey)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchCastAndCrew(with movieId: Int) async throws -> CastAndCrew {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(APIKey.apiKey)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchMovieVideo(with movieId: Int) async throws -> MovieVideoModel {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(APIKey.apiKey)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchSearchMovies(with movieName: String) async throws -> Movie {
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(movieName)&api_key=\(APIKey.apiKey)"
        return try await networkManager.request(urlString: urlString)
    }
}
