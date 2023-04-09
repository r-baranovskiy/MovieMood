import UIKit
import SDWebImage

final class HomeViewController: UIViewController {
    
    private let apiManager = ApiManager(
        networkManager: NetworkManager(jsonService: JSONDecoderManager())
    )
    
    //MARK: - Properties
    
    private var filmCovers = [UIImage]()
    
    private var movies = [MovieModel]()
    
    private var userImageView: UIImageView = {
        let userIV = UIImageView()
        userIV.clipsToBounds = true
        userIV.contentMode = .scaleAspectFill
        userIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.layer.cornerRadius = userIV.frame.height / 2
        userIV.image = UIImage(named: "mock-person")
        return userIV
    }()
    
    private var usernameLabel = UILabel(
        text: "HI, Nikolai", font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .left, color: .label
    )
    
    private let additionalInfoLabel = UILabel(
        text: "only streaming movie lovers",
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private var topStackView = UIStackView()
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategoryCollection()
        fetchMovies()
    }
    
    private func setupCategoryCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
    }
    
    // MARK: - Behaviour
    
    
    private func fetchMovies() {
        Task {
            do {
                movies = try await apiManager.fetchMovies().results
                fetchFilmCovers()
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
        let carouselView = TransformView(
            images: filmCovers, imageSize: CGSize(width: 100, height: 150),
            viewSize: CGSize(width: view.frame.width, height: 150)
        )
        
        view.addSubviewWithoutTranslates(carouselView)
        
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(
                equalTo: topStackView.bottomAnchor, constant: 100
            ),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 150)
        ])
        print(filmCovers.count)
        updateViewConstraints()
    }
    
    private func setupView() {
        let labelsStackView = UIStackView(
            subviews: [usernameLabel, additionalInfoLabel],
            axis: .vertical, spacing: 2, aligment: .leading,
            distribution: .fill
        )
        
        topStackView = UIStackView(
            subviews: [userImageView, labelsStackView], axis: .horizontal,
            spacing: 15, aligment: .leading, distribution: .fill
        )
        
        view.backgroundColor = .custom.mainBackground
        view.addSubviewWithoutTranslates(
            topStackView, categoryCollection
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
        ])
        
        NSLayoutConstraint.activate([
            //            categoryCollection.heightAnchor.constraint(equalToConstant: 50),
            //            categoryCollection.topAnchor.constraint(
            //                equalTo: carouselView.bottomAnchor, constant: 100
            //            ),
            //            categoryCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            categoryCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
