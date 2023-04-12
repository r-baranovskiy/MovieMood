import UIKit

final class ImageNetworkLoaderManager {
    
    static let shared = ImageNetworkLoaderManager()
    
    func fetchImageArray(movieModels: [Any],
                         completion: @escaping (Result<[UIImage], Error>) -> Void) {
        if let models = movieModels as? [MovieDetail] {
            guard models.count >= 15 else { return }
            let movieModels = models.shuffled()[0...14]
            var images = [UIImage]()
            let urls = movieModels.compactMap({
                URL(string: "https://image.tmdb.org/t/p/w500/\($0.poster_path ?? "")") })
            DispatchQueue.global(qos: .userInitiated).async {
                urls.forEach({
                    do {
                        let data = try Data(contentsOf: $0)
                        if let image = UIImage(data: data) {
                            images.append(image)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                })
                completion(.success(images))
            }
            return
        } else if let models = movieModels as? [TVDetail] {
            guard models.count >= 15 else { return }
            let tvModels = models.shuffled()[0...14]
            var images = [UIImage]()
            let urls = tvModels.compactMap({
                URL(string: "https://image.tmdb.org/t/p/w500/\($0.posterPath)") })
            DispatchQueue.global(qos: .userInitiated).async {
                urls.forEach({
                    do {
                        let data = try Data(contentsOf: $0)
                        if let image = UIImage(data: data) {
                            images.append(image)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                })
                completion(.success(images))
            }
        }
    }
}
