import UIKit

final class SearchViewController: UIViewController {
    
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
    
    //MARK: - Private Properties
    private let searchTextField = MovieSearchTextField()
    private let crossButton = CrossButton()
    private let filterButton = FilterButton()
    private let filterPopupView = FilterPopupView()
    
    private var movies = [MovieDetail]()
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    
    private let searchImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "search")?.withTintColor(.label))
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()
    
    
    private var moviesID: [Int] = []
    
    private lazy var tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        filterPopupView.delegate = self
        searchTextField.delegate = self
        setupSearchUI()
        addAction()
        setupCollectionView()
        //fetchMovies()
    }
    
    //MARK: - Network Methodes
    private func fetchSearchMovies(with movie: String) {
        Task {
            do {
                let movies = try await apiManager.fetchSearchMovies(with: movie).results
                for movie in movies {
                    let movie = try await apiManager.fetchMovieDetail(with: movie.id)
                    self.movies.append(movie)
                }
                await MainActor.run {
                    movieColletionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Private Methodes
    private func addAction() {
        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc private func crossButtonTapped() {
        searchTextField.text = ""
        searchTextField.endEditing(true)
    }
    
    @objc private func filterButtonTapped() {
        let heightTabBar = tabBarController?.tabBar.frame.height ?? 0
        view.addSubview(filterPopupView)
        filterPopupView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height / 2)
        UIView.animate(withDuration: 0.3) {
            self.filterPopupView.frame.origin.y -= (self.view.frame.height / 2) + heightTabBar
        }
    }
    
    private func hideFilter() {
        let heightTabBar = tabBarController?.tabBar.frame.height ?? 0
        UIView.animate(withDuration: 0.3) {
            self.filterPopupView.frame.origin.y += (self.view.frame.height / 2) + heightTabBar
        } completion: { _ in
            self.filterPopupView.removeFromSuperview()
        }
    }
}

extension SearchViewController: MovieCollectionViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?) {
        
    }
}

//MARK: - FilterPopupViewDelegate
extension SearchViewController: FilterPopupViewDelegate {
    func didTapApplyFilter(with genre: String, votes: String) {
        movies = []
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
                    self.movies.append(movie)
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
        movies = []
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
                string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"
            )
            
            var movieGenre = "none"
            if !movie.genres.isEmpty {
                movieGenre = movie.genres[0].name
            }
            
            cell.configure(url: imageUrl, movieName: movie.title,
                           duration: "\(movie.runtime ?? 0) minutes",
                           creatingDate: movie.release_date,
                           genre: movieGenre, isFavorite: false)
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let detailVC = DetailViewController(movieId: movie.id)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK: - SetupUI
extension SearchViewController {
    
    private func setupCollectionView() {
        movieColletionView.backgroundColor = .none
        view.backgroundColor = .custom.mainBackground
        view.addSubviewWithoutTranslates(movieColletionView)
        
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
    
    private func setupSearchUI() {
        view.addSubviewWithoutTranslates(
            searchTextField, crossButton, filterButton, searchImageView
        )
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35
            ),
            searchTextField.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: 24
            ),
            searchTextField.rightAnchor.constraint(
                equalTo: view.rightAnchor, constant: -24
            ),
            
            filterButton.rightAnchor.constraint(
                equalTo: searchTextField.rightAnchor, constant: -19
            ),
            filterButton.centerYAnchor.constraint(
                equalTo: searchTextField.centerYAnchor
            ),
            
            crossButton.rightAnchor.constraint(
                equalTo: searchTextField.rightAnchor, constant: -55
            ),
            crossButton.centerYAnchor.constraint(
                equalTo: searchTextField.centerYAnchor
            ),
            
            searchImageView.leftAnchor.constraint(
                equalTo: searchTextField.leftAnchor, constant: 18
            ),
            searchImageView.centerYAnchor.constraint(
                equalTo: searchTextField.centerYAnchor
            )
        ])
    }
}


