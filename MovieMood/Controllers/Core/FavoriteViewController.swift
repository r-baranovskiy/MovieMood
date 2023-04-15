import UIKit

final class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currentUser: UserRealm
    
    private var favoriteMoviesRealm = [MovieRealm]()
    private var movies = [MovieDetail]()
    
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    
    private lazy var movieColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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
        updateFavoritesId()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesId()
        fetchMovies()
    }
    
    private func updateFavoritesId() {
        RealmManager.shared.fetchMovies(
            userId: currentUser.userId, moviesType: .favorite
        ) { [weak self] realmMovies in
            guard let self = self else { return }
            for movie in realmMovies {
                if !self.checkOnContainsRealmId(movidId: movie.movieId) {
                    self.favoriteMoviesRealm.append(movie)
                }
            }
        }
    }
    
    private func fetchMovies() {
        for id in favoriteMoviesRealm {
                Task {
                    do {
                        let movie = try await apiManager.fetchMovieDetail(with: id.movieId)
                        if !checkOnContainsMovie(movidId: movie.id) {
                            movies.insert(movie, at: 0)
                        }
                        await MainActor.run(body: {
                            movieColletionView.reloadData()
                        })
                    }
                }
        }
    }
    
    private func checkOnContainsRealmId(movidId: Int) -> Bool {
        return favoriteMoviesRealm.contains(where: { $0.movieId == movidId })
    }
    
    private func checkOnContainsMovie(movidId: Int) -> Bool {
        return movies.contains(where: { $0.id == movidId })
    }
}

// MARK: - MovieCollectionViewCellDelegate

extension FavoriteViewController: MovieCollectionViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let movieId = movies[indexPath.row]
        RealmManager.shared.removeMovie(for: currentUser, with: movieId.id)
        { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.movies.remove(at: indexPath.row)
                    self?.movieColletionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
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
            string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"
        )
        let isFavorite = RealmManager.shared.isLikedMovie(
            for: currentUser, with: movie.id
        )
        
        cell.configure(url: imageUrl, movieName: movie.title,
                       duration: "\(movie.runtime ?? 0) minutes",
                       creatingDate: movie.release_date,
                       genre: "Action", isFavorite: isFavorite)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let isFavorite = RealmManager.shared.isLikedMovie(for: currentUser, with: movie.id)
        let detailVC = DetailViewController(
            movieId: movie.id, isFavorite: isFavorite,
            currentUser: currentUser
        )
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width / 2)
    }
}

// MARK: - Setup View

extension FavoriteViewController {
    private func setupView() {
        view.backgroundColor = .custom.mainBackground
        movieColletionView.backgroundColor = .clear
        
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
