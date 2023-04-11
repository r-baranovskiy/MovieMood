import UIKit

final class HistoryViewController: UIViewController {
    
    private let currentUser: UserRealm
    
    // MARK: - Collection View
    
    private lazy var movieColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.frame.width,
            height: view.frame.width / 2)
        layout.scrollDirection = .vertical
        let collection = UICollectionView(
            frame: .zero,collectionViewLayout: layout
        )
        collection.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )
        
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    // MARK: - Properties
    
    private var movies = [MovieModel]()
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    
    init(currentUser: UserRealm) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        Task {
            do {
                movies = try await apiManager.fetchMovies().results
                await MainActor.run(body: {
                    movieColletionView.reloadData()
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension HistoryViewController: MovieCollectionViewCellDelegate {
    func didTapLike() {
        print("Like")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HistoryViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.identifier,
                for: indexPath) as? MovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            let movie = movies[indexPath.row]
            let imageUrl = URL(
                string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"
            )
            
            let isFavorite = RealmManager.shared.isLikedMovie(for: currentUser, with: String(movie.id))
            cell.configure(url: imageUrl, movieName: movie.title,
                           duration: 0, creatingDate: movie.release_date,
                           genre: "Action", isFavorite: isFavorite)
            return cell
        }
}

// MARK: - Setup View

extension HistoryViewController {
    private func setupView() {
        view.backgroundColor = .custom.mainBackground
        
        view.addSubviewWithoutTranslates(movieColletionView)
        NSLayoutConstraint.activate([
            movieColletionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            movieColletionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            movieColletionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            movieColletionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            )
        ])
    }
}
