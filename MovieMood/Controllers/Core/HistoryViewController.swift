import UIKit

final class HistoryViewController: UIViewController {
    
    private let currentUser: UserRealm
    
    private var recentMovies = [MovieDetail]()
    
    private var nonFilteredReecentMovies = [MovieDetail]()
    
    private var recentMoviesId = [MovieRealm]()
    
    private let categoriesScrollView = CategoryScrollView(withTV: false)
    
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
        collection.backgroundColor = .none
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    // MARK: - Properties
    
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
        categoriesScrollView.buttonDelegate = self
        setupView()
        updateRecentMoviesId()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRecentMoviesId()
        fetchMovies()
    }
    
    private func updateRecentMoviesId() {
        recentMoviesId = []
        RealmManager.shared.fetchMovies(
            userId: currentUser.userId, moviesType: .recent
        ) { [weak self] movies in
            self?.recentMoviesId = movies
        }
    }
    
    private func fetchMovies() {
        for id in recentMoviesId {
            Task {
                do {
                    let movie = try await apiManager.fetchMovieDetail(with: id.movieId)
                    if !checkOnContains(movidId: id.movieId) {
                        recentMovies.insert(movie, at: 0)
                        await MainActor.run(body: {
                            nonFilteredReecentMovies = recentMovies
                            movieColletionView.reloadData()
                        })
                    }
                }
            }
        }
    }
    
    private func checkOnContains(movidId: Int) -> Bool {
        return recentMovies.contains(where: { $0.id == movidId })
    }
}

extension HistoryViewController: CategoryScrollViewDelegate {
    func didChangeCategory(with tag: Int) {
        if tag == 0 {
            recentMovies = nonFilteredReecentMovies
            DispatchQueue.main.async {
                self.movieColletionView.reloadData()
            }
        }
        guard tag != 0 else { return }
        recentMovies = []
        for movie in nonFilteredReecentMovies {
            for genre in movie.genres {
                if genre.id == tag {
                    recentMovies.append(movie)
                }
            }
        }
        DispatchQueue.main.async {
            self.movieColletionView.reloadData()
        }
    }
}

// MARK: - MovieCollectionViewCellDelegate

extension HistoryViewController: MovieCollectionViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let movieId = recentMovies[indexPath.row].id
        
        if !RealmManager.shared.isLikedMovie(for: currentUser, with: movieId) {
            RealmManager.shared.saveMovie(
                for: currentUser, with: movieId, moviesType: .favorite
            ) { [weak self] success in
                DispatchQueue.main.async {
                    self?.movieColletionView.reloadData()
                }
            }
        } else {
            RealmManager.shared.removeMovie(for: currentUser,
                                            with: movieId) { success in
                if success {
                    print("Deleted")
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
        recentMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = recentMovies[indexPath.row]
        let isFavorite = RealmManager.shared.isLikedMovie(for: currentUser, with: movie.id)
        let detailVC = DetailViewController(
            movieId: movie.id, isFavorite: isFavorite,
            currentUser: currentUser
        )
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
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
            let movie = recentMovies[indexPath.row]
            
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

// MARK: - Setup View

extension HistoryViewController {
    private func setupView() {
        view.backgroundColor = .custom.mainBackground
        view.addSubviewWithoutTranslates(categoriesScrollView, movieColletionView)
        
        NSLayoutConstraint.activate([
            categoriesScrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19
            ),
            categoriesScrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            ),
            categoriesScrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -24
            ),
            
            categoriesScrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            movieColletionView.topAnchor.constraint(
                equalTo: categoriesScrollView.bottomAnchor, constant: 24
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
