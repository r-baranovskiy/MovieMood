import UIKit

final class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currentUser: UserRealm
    
    private var favoriteMovies = [MovieModel]()
    
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
    }
    
    // MARK: - Actions
    
}

extension FavoriteViewController: MovieCollectionViewCellDelegate {
    func didTapLike(withIndexPath indexPath: IndexPath?) {
        <#code#>
    }
}

// MARK: - UICollectionViewDataSource

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        favoriteMovies.count
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
        let movie = favoriteMovies[indexPath.row]
        let imageUrl = URL(
            string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"
        )
        
        let isFavorite = RealmManager.shared.isLikedMovie(
            for: currentUser, with: String(movie.id)
        )
        
        cell.configure(url: imageUrl, movieName: movie.title,
                       duration: 0, creatingDate: movie.release_date,
                       genre: "Action", isFavorite: isFavorite)
        return cell
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
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
