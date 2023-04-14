import UIKit
import SDWebImage

enum ShowType {
    case movies
    case tv
}

final class HomeViewController: UIViewController {
        
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    
    //MARK: - Properties
    
    private let currentUser: UserRealm
    
    private var filmCovers = [UIImage]()
    private var popularMovies = [MovieDetail]()
    private var ratingTV = [TVDetail]()
    private var showType: ShowType?
    
    private var userImageView: UIImageView = {
        let userIV = UIImageView()
        userIV.clipsToBounds = true
        userIV.contentMode = .scaleAspectFill
        userIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.layer.cornerRadius = userIV.frame.height / 2
        return userIV
    }()
    
    private lazy var spiner: UIActivityIndicatorView = {
        let active = UIActivityIndicatorView(style: .large)
        let size = CGSize(width: 100, height: 100)
        active.frame = CGRect(
            x: (animateContainerView.frame.width - size.width) / 2,
            y: (animateContainerView.frame.height - size.height) / 2,
            width: size.width, height: size.height
        )
        print(animateContainerView)
        active.hidesWhenStopped = true
        return active
    }()
    
    private let categoriesScrollView = CategoryScrollView(withTV: true)
    
    private var usernameLabel = UILabel(
        font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .left, color: .label
    )
    
    private let additionalInfoLabel = UILabel(
        text: "only streaming movie lovers",
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let animateContainerHeigh: CGFloat = 100
    private let animateContainerView = UIView()
    
    private let moviesTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
        return table
    }()
    
    // MARK: - Init
    
    init(currentUser: UserRealm) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        updateUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        settings()
        updateData(with: .movies)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUser()
    }
    
    // MARK: - Behaviour
    
    private func settings() {
        categoriesScrollView.buttonDelegate = self
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }
    
    private func updateUser() {
        usernameLabel.text = currentUser.firstName != "" ? "HI, \(currentUser.firstName)" : "Hi, Guest"
        if let userImageData = currentUser.userImageData {
            userImageView.image = UIImage(data: userImageData)
        } else {
            userImageView.image = UIImage(named: "mock-person")
        }
    }
    
    private func updateData(with category: ShowType) {
        switch category {
        case .movies:
            fetchMovies()
        case .tv:
            fetchTV()
        }
    }
    
    private func fetchTV() {
        showType = .tv
        Task {
            do {
                let shows = try await apiManager.fetchRatingTV().results
                for tv in shows {
                    let show = try await apiManager.fetchTVDetail(with: tv.id)
                    ratingTV.append(show)
                }
                fetchFilmCovers(with: ratingTV)
                await MainActor.run {
                    moviesTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchMovies() {
        showType = .movies
        Task {
            do {
                let movies = try await apiManager.fetchMovies().results
                for movie in movies {
                    let movie = try await apiManager.fetchMovieDetail(with: movie.id)
                    popularMovies.append(movie)
                }
                fetchFilmCovers(with: popularMovies)
                await MainActor.run {
                    moviesTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchFilmCovers(with models: [Any]) {
        animateContainerView.addSubview(spiner)
        spiner.startAnimating()
        ImageNetworkLoaderManager.shared.fetchImageArray(movieModels: models) { [weak self] result in
            switch result {
            case .success(let images):
                self?.filmCovers = images
                DispatchQueue.main.async {
                    self?.showHeaderFilms()
                    self?.spiner.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: CategoryScrollViewDelegate {
    func didChangeCategory(with tag: Int) {
        switch tag {
        case 0:
            filmCovers = []
            updateData(with: .movies)
            for subview in animateContainerView.subviews {
                if subview != spiner {
                    subview.removeFromSuperview()
                }
            }
        case 1:
            filmCovers = []
            updateData(with: .tv)
            for subview in animateContainerView.subviews {
                if subview != spiner {
                    subview.removeFromSuperview()
                }
            }
        default:
            break
        }
    }
}

// MARK: - MovieTableViewCellDelegate

extension HomeViewController: MovieTableViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?, forType type: ShowType?) {
        guard let type = type, let indexPath = indexPath else { return }
        
        var id: Int?
        
        switch type {
        case .movies:
            let movieId = popularMovies[indexPath.row].id
            id = movieId
        case .tv:
            let showId = ratingTV[indexPath.row].id
            id = showId
        }
        
        guard let id = id else { return }
        
        if !RealmManager.shared.isLikedMovie(for: currentUser, with: id) {
            RealmManager.shared.saveMovie(
                for: currentUser, with: id, moviesType: .favorite
            ) { _ in
                print("Liked")
            }
        } else {
            RealmManager.shared.removeMovie(for: currentUser, with: id) { _ in
                print("Deleted")
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = showType else { return }
        switch type {
        case .movies:
            let movie = popularMovies[indexPath.row]
            
            if !RealmManager.shared.isAddedToRecentMovie(for: currentUser,
                                                         with: movie.id) {
                RealmManager.shared.saveMovie(for: currentUser, with: movie.id,
                                              moviesType: .recent) { success in
                    print("Saved")
                }
            }
            let detailVC = DetailViewController(movieId: movie.id)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        case .tv:
            let tv = ratingTV[indexPath.row]
            let detailVC = TVDetailsViewController(tv: tv)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = showType else { return 0 }
        switch type {
        case .movies:
            return popularMovies.count
        case .tv:
            return ratingTV.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier, for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }
        
        guard let type = showType else { return UITableViewCell() }
        
        switch type {
        case .movies:
            let movie = popularMovies[indexPath.row]
            let imageUrl = URL(
                string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path ?? "")"
            )
            let isFavorite = RealmManager.shared.isLikedMovie(for: currentUser, with: movie.id)
            cell.configure(url: imageUrl, movieName: movie.title,
                           duration: "\(movie.runtime ?? 0) minutes",
                           isFavorite: isFavorite,
                           genre: movie.genres.first?.name ?? "",
                           votesAmoutCount: movie.vote_count,
                           rate: movie.vote_average
            )
            cell.showType = .movies
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        case .tv:
            let tv = ratingTV[indexPath.row]
            let imageUrl = URL(
                string: "https://image.tmdb.org/t/p/w500/\(tv.posterPath)"
            )
            let isFavorite = RealmManager.shared.isLikedMovie(for: currentUser, with: tv.id)
            cell.configure(
                url: imageUrl, movieName: tv.name,
                duration: "Episodes: \(tv.numberOfEpisodes)",
                isFavorite: isFavorite, genre: tv.genres.first?.name ?? "",
                votesAmoutCount: tv.voteCount, rate: tv.voteAverage
            )
            cell.showType = .tv
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - Setup View

extension HomeViewController {
    private func showHeaderFilms() {
        let height = animateContainerHeigh
        let carouselView = TransformView(
            images: filmCovers,
            imageSize: CGSize(
                width: height * 0.66,
                height: animateContainerHeigh
            ),
            viewSize: CGSize(
                width: view.frame.width, height: animateContainerHeigh
            )
        )
        animateContainerView.addSubview(carouselView)
        carouselView.frame = animateContainerView.bounds
        
    }
    
    private func setupView() {
        let labelsStackView = UIStackView(
            subviews: [usernameLabel, additionalInfoLabel],
            axis: .vertical, spacing: 2, aligment: .leading,
            distribution: .fill
        )
        
        let topStackView = UIStackView(
            subviews: [userImageView, labelsStackView], axis: .horizontal,
            spacing: 15, aligment: .leading, distribution: .fill
        )
        
        view.backgroundColor = .custom.mainBackground
        view.addSubviewWithoutTranslates(
            topStackView, animateContainerView,
            categoriesScrollView, moviesTableView
        )
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16
            ),
            topStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            ),
            topStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: 24
            ),
            topStackView.heightAnchor.constraint(equalToConstant: 40),
            
            animateContainerView.topAnchor.constraint(
                equalTo: topStackView.bottomAnchor, constant: 50
            ),
            animateContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            animateContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            animateContainerView.heightAnchor.constraint(
                equalToConstant: animateContainerHeigh
            )
        ])
        
        NSLayoutConstraint.activate([
            categoriesScrollView.heightAnchor.constraint(
                equalToConstant: 40
            ),
            categoriesScrollView.topAnchor.constraint(
                equalTo: animateContainerView.bottomAnchor, constant: 50
            ),
            categoriesScrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16
            ),
            categoriesScrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            moviesTableView.topAnchor.constraint(
                equalTo: categoriesScrollView.bottomAnchor, constant: 10
            ),
            moviesTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10
            ),
            moviesTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 0
            ),
            moviesTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: 0
            )
        ])
    }
}
