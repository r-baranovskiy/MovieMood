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
    private let searchMovie = MovieSearchTextField()
    private let crossButton = CrossButton()
    private let filterButton = FilterButton()
    private let searchImageView = SearchView(frame: CGRect())
    private let filterPopupView = FilterPopupView()
    
    private var moviesModel = [MovieModel]()
    private var movies = [MovieDetail]()
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    private var moviesID: [Int] = []
    
    private lazy var tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        filterPopupView.delegate = self
        searchMovie.delegate = self
        setupSearchUI()
        addAction()
        setupCollectionView()
        //fetchMovies()
    }
    
    //MARK: - Network Methodes
    private func fetchSearchMovies(with movie: String) {
        Task {
            do {
                moviesModel = try await apiManager.fetchSearchMovies(with: movie).results
                for movie in moviesModel {
                    moviesID.append(movie.id)
                }
                await MainActor.run(body: {
                    fetchDetailMovies()
                    movieColletionView.reloadData()
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchDetailMovies() {
        for id in moviesID {
            Task {
                do {
                    let movie = try await apiManager.fetchMovieDetail(with: id)
                    movies.append(movie)
                    await MainActor.run(body: {
                        movieColletionView.reloadData()
                    })
                } catch {
                    print(error)
                }
            }
        }
    }
    
//    private func fetchMovies() {
//        Task {
//            do {
//                moviesModel = try await apiManager.fetchMovies().results
//                await MainActor.run(body: {
//                    movieColletionView.reloadData()
//                })
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
    //MARK: - Private Methodes
    private func addAction() {
        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    @objc private func crossButtonTapped() {
        searchMovie.text = ""
        searchMovie.endEditing(true)
    }
    
    @objc private func filterButtonTapped() {
        let heightTabBar = tabBarController?.tabBar.frame.height ?? 0
        view.addSubview(filterPopupView)
        filterPopupView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height / 2)
        print(view.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.filterPopupView.frame.origin.y -= (self.view.frame.height / 2) + heightTabBar
        }
    }
    
    //MARK: - Filters Methodes
    private func searchByGenre(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("hi")
        default:
            break
        }
    }
    
}

extension SearchViewController: MovieCollectionViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?) {
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
        fetchSearchMovies(with: movie)
        textField.text = ""
        textField.endEditing(true)
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let movie = textField.text, movie.count != 0 else { return true }
//        fetchSearchMovies(with: movie)
//        return true
//    }
    
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
                           duration: movie.runtime ?? 0, creatingDate: movie.release_date,
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

//MARK: - FilterPopupViewDelegate
extension SearchViewController: FilterPopupViewDelegate {
    func didTapApplyFilter(with filter: [String]) {
        print(filter)
    }
}

//MARK: - SetupUI
extension SearchViewController {
    
    private func setupCollectionView() {
        view.backgroundColor = .custom.mainBackground
        view.addSubviewWithoutTranslates(movieColletionView)
        
        NSLayoutConstraint.activate([
            movieColletionView.topAnchor.constraint(equalTo: searchMovie.bottomAnchor, constant: 30),
            movieColletionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            movieColletionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieColletionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupSearchUI() {
        view.addSubviewWithoutTranslates(searchMovie, crossButton, filterButton, searchImageView)
        
        NSLayoutConstraint.activate([
            searchMovie.topAnchor.constraint(equalTo: navigationItem.titleView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 35),
            searchMovie.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            searchMovie.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            filterButton.rightAnchor.constraint(equalTo: searchMovie.rightAnchor, constant: -19),
            filterButton.centerYAnchor.constraint(equalTo: searchMovie.centerYAnchor),
            
            crossButton.rightAnchor.constraint(equalTo: searchMovie.rightAnchor, constant: -55),
            crossButton.centerYAnchor.constraint(equalTo: searchMovie.centerYAnchor),
            
            searchImageView.leftAnchor.constraint(equalTo: searchMovie.leftAnchor, constant: 18),
            searchImageView.centerYAnchor.constraint(equalTo: searchMovie.centerYAnchor)
        ])
    }
}


