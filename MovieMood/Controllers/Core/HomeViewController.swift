import UIKit
import SDWebImage

final class HomeViewController: UIViewController {
    
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    
    //MARK: - Properties
    
    private let currentUser: UserRealm
    
    private var filmCovers = [UIImage]()
    private var movies = [MovieModel]()
    
    private var userImageView: UIImageView = {
        let userIV = UIImageView()
        userIV.clipsToBounds = true
        userIV.contentMode = .scaleAspectFill
        userIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.layer.cornerRadius = userIV.frame.height / 2
        return userIV
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
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
        return table
    }()
    
    // MARK: - Collection
    
    private let categoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let colletion = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        colletion.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        layout.estimatedItemSize = CGSize(width: 100, height: 30)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        colletion.contentInsetAdjustmentBehavior = .always
        colletion.backgroundColor = .clear
        colletion.bounces = false
        colletion.showsHorizontalScrollIndicator = false
        return colletion
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
        setDelegates()
        fetchMovies()
    }
    
    private func setDelegates() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
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
    
    // MARK: - Behaviour
    
    private func fetchMovies() {
        Task {
            do {
                movies = try await apiManager.fetchMovies().results
                fetchFilmCovers()
                await MainActor.run {
                    moviesTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchFilmCovers() {
        ImageNetworkLoaderManager.shared.fetchImageArray(movieModels: movies) { [weak self] result in
            switch result {
            case .success(let images):
                self?.filmCovers = images
                DispatchQueue.main.async {
                    self?.showHeaderFilms()
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
        let movie = movies[indexPath.row]
        
        let detailVC = DetailViewController(movieId: movie.id)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier, for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        let imageUrl = URL(
            string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"
        )
        cell.configure(url: imageUrl, movieName: movie.title,
                       duration: 120, genre: "Erotic",
                       votesAmoutCount: 288, rate: 5.5)
        return cell
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
            categoryCollection, moviesTableView
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
            categoryCollection.heightAnchor.constraint(equalToConstant: 50),
            categoryCollection.topAnchor.constraint(
                equalTo: animateContainerView.bottomAnchor, constant: 50
            ),
            categoryCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            moviesTableView.topAnchor.constraint(
                equalTo: categoryCollection.bottomAnchor, constant: 10
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
