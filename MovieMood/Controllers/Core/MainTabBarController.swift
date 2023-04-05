import UIKit

final class MainTabBarController: UITabBarController {
    
    private let apiManager: ApiManagerProtocol = ApiManager(networkManager: NetworkManager(jsonService: JSONDecoderManager()))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        fetchMovies()
        fetchMovieDetail()
    }
}

extension MainTabBarController {
    func fetchMovies() {
        Task(priority: .userInitiated) {
            do {
                let movies = try await apiManager.fetchMovies()
                await MainActor.run(body: {
                    print(movies)
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
    
    func fetchMovieDetail() {
        Task(priority: .userInitiated) {
            do {
                let movieDetail = try await apiManager.fetchMovieDetail(with: 980078)
                await MainActor.run(body: {
                    print(movieDetail)
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
}
