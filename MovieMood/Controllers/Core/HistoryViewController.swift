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
        fetchMovies()
    }
    
    private func fetchMovies() {
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

// MARK: - MovieCollectionViewCellDelegate

extension HistoryViewController: MovieCollectionViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let movieId = movies[indexPath.row].id
        
        if !RealmManager.shared.isLikedMovie(for: currentUser, with: movieId) {
            RealmManager.shared.saveMovie(
                for: currentUser, with: movies[indexPath.row].id
            ) { [weak self] success in
                    DispatchQueue.main.async {
                        self?.movieColletionView.reloadData()
                    }
                }
        } else {
            RealmManager.shared.removeMovie(for: currentUser,
                                            with: movieId) { success in
                if success {
                    print("УДАЛЕННОООО")
                }
            }
        }
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
            cell.indexPath = indexPath
            let movie = movies[indexPath.row]
            let imageUrl = URL(
                string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"
            )
            
            let isFavorite = RealmManager.shared.isLikedMovie(
                for: currentUser, with: movie.id
            )
            
            cell.configure(url: imageUrl, movieName: movie.title,
                           duration: 0, creatingDate: movie.release_date,
                           genre: "Action", isFavorite: isFavorite)
            return cell
        }
        cell.delegate = self
        let movie = movies[indexPath.row]
        let imageUrl = URL(
            string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"
        )
        cell.configure(url: imageUrl, movieName: movie.title,
                       duration: 0, creatingDate: movie.release_date,
                       genre: "Action")
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
