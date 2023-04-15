import Foundation

protocol ApiManagerProtocol {
    func fetchMovies() async throws -> Movie
    func fetchRaitingMovies() async throws -> Movie
    func fetchMovieDetail(with movieId: Int) async throws -> MovieDetail
    func fetchCastAndCrew(with movieId: Int) async throws -> CastAndCrew
    func fetchMovieVideo(with movieId: Int) async throws -> MovieVideoModel
    func fetchSearchMovies(with movieName: String) async throws -> Movie
    func fetchRatingTV() async throws -> TV
    func fetchTVDetail(with tvId: Int) async throws -> TVDetail
    func fetchFilterMovies(with genre: Int, votes: Int) async throws -> Movie
    func fetchTvVideo(with tvId: Int) async throws ->  MovieVideoModel
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
    
    func fetchRaitingMovies() async throws -> Movie {
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKey.apiKey)&language=en-US&page=1"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchFilterMovies(with genre: Int, votes: Int) async throws -> Movie {
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(APIKey.apiKey)&with_genres=\(genre)&vote_average.gte=\(votes)"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchRatingTV() async throws -> TV {
        let urlString = "https://api.themoviedb.org/3/tv/top_rated?api_key=\(APIKey.apiKey)&language=en-US&page=1"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchTVDetail(with tvId: Int) async throws -> TVDetail {
        let urlString = "https://api.themoviedb.org/3/tv/\(tvId)?api_key=\(APIKey.apiKey)&language=en-US"
        return try await networkManager.request(urlString: urlString)
    }

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
    
    func fetchTvVideo(with tvId: Int) async throws -> MovieVideoModel {
        let urlString = "https://api.themoviedb.org/3/tv/\(tvId)/videos?api_key=\(APIKey.apiKey)"
        return try await networkManager.request(urlString: urlString)
    }
    
}
