import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private var popularMovies = [MovieDetail]()
    private let currentUser: UserRealm
    
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(
            target: view,action: #selector(view.endEditing)
        )
    }()
    
    //MARK: - Views
    
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
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let blur = UIVisualEffectView(effect: effect)
        return blur
    }()
    
    private lazy var filterPopupView = FilterPopupView()
    
    private let searchTextField = MovieSearchTextField()
    
    // MARK: - Init
    
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
        searchTextField.addTarget(self, action: #selector(didChangeSearchText(_:)), for: .editingChanged)
        searchTextField.delegate = self
        searchTextField.searchFieldDelegate = self
        setupCollectionView()
        fetchPopularMovies()
    }
    
    @objc
    private func didChangeSearchText(_ sender: UITextField) {
        guard let text = sender.text else { return }
        popularMovies = []
        fetchSearchMovies(with: text)
    }
    
    //MARK: - Network Methodes
    private func fetchSearchMovies(with movie: String) {
        popularMovies = []
        Task {
            do {
                let movies = try await apiManager.fetchSearchMovies(with: movie).results
                for movie in movies {
                    let movie = try await apiManager.fetchMovieDetail(with: movie.id)
                    self.popularMovies.append(movie)
                }
                await MainActor.run {
                    movieColletionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchPopularMovies() {
        Task {
            do {
                let movies = try await apiManager.fetchMovies().results
                for movie in movies {
                    let movie = try await apiManager.fetchMovieDetail(with: movie.id)
                    self.popularMovies.append(movie)
                }
                await MainActor.run(body: {
                    movieColletionView.reloadData()
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func hideFilter() {
        UIView.animate(withDuration: 0.3) {
            self.filterPopupView.frame.origin.y += self.view.frame.height / 2
        } completion: { _ in
            self.filterPopupView.removeFromSuperview()
            self.blurView.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

// MARK: - MovieSearchTextFieldDelegate

extension SearchViewController: MovieSearchTextFieldDelegate {
    func didTapCrossButton() {
        searchTextField.text = nil
        searchTextField.endEditing(true)
    }
    
    func didTapFilterButton() {
        showFilteView()
    }
}

extension SearchViewController: MovieCollectionViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let movieId = popularMovies[indexPath.row].id
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

//MARK: - FilterPopupViewDelegate
extension SearchViewController: FilterPopupViewDelegate {
    func didTapClose() {
        hideFilter()
    }
    
    func didTapApplyFilter(with genre: String, votes: String) {
        popularMovies = []
        hideFilter()
        let genres = [
            "Horror": 27, "Action": 28, "Adventure": 12,
            "Mystery": 9648, "Fantasy": 14, "Comedy": 35
        ]
        
        Task {
            do {
                let movies = try await apiManager.fetchFilterMovies(
                    with: genres[genre] ?? 28, votes: votes.count * 2
                ).results
                for movie in movies {
                    let movie = try await apiManager.fetchMovieDetail(with: movie.id)
                    self.popularMovies.append(movie)
                }
                await MainActor.run {
                    movieColletionView.reloadData()
                }
            } catch {
                print("Error")
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.removeGestureRecognizer(tapGesture)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let movie = textField.text, movie.count != 0 else { return true }
        popularMovies = []
        fetchSearchMovies(with: movie)
        textField.text = ""
        textField.endEditing(true)
        return true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        popularMovies.count
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
            let movie = popularMovies[indexPath.row]
            let imageUrl = URL(
                string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"
            )
            
            var movieGenre = "none"
            if !movie.genres.isEmpty {
                movieGenre = movie.genres[0].name
            }
            let isFavorite = RealmManager.shared.isLikedMovie(for: currentUser, with: movie.id)
            cell.configure(url: imageUrl, movieName: movie.title,
                           duration: "\(movie.runtime ?? 0) minutes",
                           creatingDate: movie.release_date,
                           genre: movieGenre, isFavorite: isFavorite)
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = popularMovies[indexPath.item]
        
        if !RealmManager.shared.isAddedToRecentMovie(for: currentUser,
                                                     with: movie.id) {
            RealmManager.shared.saveMovie(for: currentUser, with: movie.id,
                                          moviesType: .recent) { success in
                print("Saved")
            }
        }
        
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

// MARK: - BlurView

extension SearchViewController {
    private func showFilteView() {
        let frameForFilteView = CGRect(
            x: 0, y: view.frame.height,
            width: view.frame.width, height: view.frame.height / 2
        )
        tabBarController?.tabBar.isHidden = true
        
        filterPopupView.delegate = self
        view.addSubview(blurView)
        blurView.frame = view.bounds
        blurView.contentView.addSubview(filterPopupView)
        filterPopupView.frame = frameForFilteView
        UIView.animate(withDuration: 0.3) {
            self.filterPopupView.frame.origin.y -= self.view.frame.height / 2
        }
    }
}

//MARK: - SetupUI
extension SearchViewController {
    
    private func setupCollectionView() {
        movieColletionView.backgroundColor = .none
        view.backgroundColor = .custom.mainBackground
        view.addSubviewWithoutTranslates(searchTextField, movieColletionView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16
            ),
            searchTextField.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: 24
            ),
            searchTextField.rightAnchor.constraint(
                equalTo: view.rightAnchor, constant: -24
            )
        ])
        
        NSLayoutConstraint.activate([
            movieColletionView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor, constant: 24
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
