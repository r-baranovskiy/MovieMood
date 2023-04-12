import UIKit
import SDWebImage

final class HomeViewController: UIViewController {
    
    enum ShowType {
        case movies
        case tv
    }
    
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
    
    private let cateforySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Films", "TV"])
        control.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ], for: .normal)
        control.backgroundColor = .custom.mainBackground
        control.selectedSegmentTintColor = .custom.mainBlue
        control.selectedSegmentIndex = 0
        return control
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
    
    private var categories = CategoryCellViewModel.fetchCategories()
    
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
    
    // MARK: - Actions
    
    @objc
    private func didChangeControl(_ sender: UISegmentedControl) {
        for subview in animateContainerView.subviews {
            if subview != spiner {
                subview.removeFromSuperview()
            }
        }
        switch sender.selectedSegmentIndex {
        case 0:
            filmCovers = []
            updateData(with: .movies)
        case 1:
            filmCovers = []
            updateData(with: .tv)
        default:
            break
        }
    }
    
    // MARK: - Behaviour
    
    private func settings() {
        cateforySegmentedControl.addTarget(
            self, action: #selector(didChangeControl), for: .valueChanged
        )
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            cell.configure(url: imageUrl, movieName: movie.title,
                           duration: 120, genre: "Erotic",
                           votesAmoutCount: 288, rate: 5.5)
            return cell
        case .tv:
            let tv = ratingTV[indexPath.row]
            let imageUrl = URL(
                string: "https://image.tmdb.org/t/p/w500/\(tv.posterPath)"
            )
            cell.configure(url: imageUrl, movieName: tv.name,
                           duration: 40, genre: "TV",
                           votesAmoutCount: tv.voteCount, rate: tv.voteAverage
            )
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        categories.enumerated().forEach { index, value in
            if index == indexPath.row {
                categories[index].isSelected = true
            } else {
                categories[index].isSelected = false
            }
        }
        categories = categories.map {
            CategoryCellViewModel(title: $0.title, isSelected: $0.isSelected)
        }
        collectionView.reloadData()
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
            cateforySegmentedControl, moviesTableView
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
            cateforySegmentedControl.heightAnchor.constraint(
                equalToConstant: 30
            ),
            cateforySegmentedControl.topAnchor.constraint(
                equalTo: animateContainerView.bottomAnchor, constant: 50
            ),
            cateforySegmentedControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16
            ),
            cateforySegmentedControl.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            moviesTableView.topAnchor.constraint(
                equalTo: cateforySegmentedControl.bottomAnchor, constant: 10
            ),
            moviesTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10
            ),
            moviesTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 12
            ),
            moviesTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -12
            )
        ])
    }
}
