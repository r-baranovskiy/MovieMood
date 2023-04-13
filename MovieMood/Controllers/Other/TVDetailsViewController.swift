import UIKit
import SDWebImage
import SafariServices

final class TVDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainScrollView = UIScrollView()
    
    private let tvImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tvNameLabel = UILabel(
        font: .systemFont(ofSize: 24, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    //  Date block_________________________________________________________
    
    private let dateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "calendar-icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let firstAirLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let lastAirLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let dashImageView: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "arrow.right.to.line"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Seasons block_______________________________________________________________
    
    private let seasonsAmountLable = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .black
    )
    
    private let valueOfSeasonsTextLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let seasonsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Episodes block______________________________________________________________
    
    private let episodesAmountLable = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .black
    )
    
    private let valueOfEpisodesTextLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let episodesStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Genre block ______________________________________________________________
    
    private let genreImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "film-icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let horizontalInformationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.contentMode = .center
        return stackView
    }()
    
    // Stars block__________________________________________________________________
    
    private let starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .center
        return stackView
    }()
    
    // Description Block ___________________________________________________________
    
    private let storyLineLabel = UILabel(
        text: "Story Line", font: .systemFont(ofSize: 16, weight: .semibold),
        textAlignment: .left, color: .label, numberOfLines: 0
    )
    
    private let textView: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 14)
        text.textColor = .custom.lightGray
        text.numberOfLines = 0
        return text
    }()
    
    // Cast and Crew Block _________________________________________________________
    
    private let castAndCrewLabel = UILabel(
        font: .systemFont(ofSize: 16, weight: .semibold),
        textAlignment: .left, color: .label
    )
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collection.dataSource = self
        return collection
    }()
    
    // Button BLock_________________________________________________________________
    
    private lazy var watchButton: BlueButton = {
        let button = BlueButton(withStyle: .ation)
        button.setTitle("Watch now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 24
        button.addTarget(nil, action: #selector(loadYouTubeVideo), for: .touchUpInside)
        return button
    }()
    
    // API Block____________________________________________________________________
    
    private let apiManager: ApiManagerProtocol = ApiManager(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    private var detailTV: TVDetail?
    private var model: CastAndCrew?
    private var movieVideo: MovieVideoModel?
    private var cast: [Cast] = []
    private var crew: [Crew] = []
    private var rating: Double?
    private var videoID: String? = nil
    
    private let tvId: Int
    
    init(tvId: Int) {
        self.tvId = tvId
        super.init(nibName: nil, bundle: nil)
        configure(idTV: tvId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // LifeCycle BLock___________________________________________________________________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "\(DetailCollectionViewCell.self)")
        title = "Movie Detail"
        navigationController?.navigationBar.backItem?.backBarButtonItem?.image = UIImage(named: "back-button-icon")
        setupUI()
    }
    
    // Methods BLock_____________________________________________________________________________________
    
    func configure(idTV: Int){
        Task {
            detailTV = try? await apiManager.fetchMovieDetail(with: tvId)
            model = try? await apiManager.fetchCastAndCrew(with: tvId)
            movieVideo = try? await apiManager.fetchMovieVideo(with: tvId)
            await MainActor.run(body: {
                tvNameLabel.text = detailTV?.name
                firstAirLabel.text = detailTV?.firstAirDate
                lastAirLabel.text = detailTV?.lastAirDate
                if let name = detailTV?.genres, !name.isEmpty {
                    genreLabel.text = name[0].name
                }
                valueOfSeasonsTextLabel.text = String(detailTV?.numberOfSeasons)
                valueOfEpisodesTextLabel.text = String(detailTV?.numberOfEpisodes)
                textView.text = "По сути, тут должно быть описание из API"
                //                textView.text = detailMovie?.overview
                rating = detailTV?.voteAverage
                if let poster = detailTV?.posterPath {
                    tvImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(poster)"))
                }
                getStarsImage(with: rating ?? 0)
                if let tvId = movieVideo?.results, !tvId.isEmpty {
                    videoID = tvId[0].key
                }
                cast = model?.cast ?? []
                crew = model?.crew ?? []
                collectionView.reloadData()
            })
        }
    }
    
    @objc private func loadYouTubeVideo() {
        guard let videoID = videoID,
              let url = URL(
                string: "https://www.youtube.com/watch?v=\(videoID)"
              ) else { return }
        let safari = SFSafariViewController(url: url)
        self.present(safari, animated: true)
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        return layout
    }
    
    private func getStarsImage(with stars: Double) {
        switch stars {
        case 0..<2:
            for _ in 1...5 {
                let star = UIImageView(image: UIImage(named: "star"))
                starsStackView.addArrangedSubview(star)
            }
        case 2..<4:
            let star1 = UIImageView(image: UIImage(named: "star1"))
            starsStackView.addArrangedSubview(star1)
            for _ in 1...4 {
                let star = UIImageView(image: UIImage(named: "star"))
                starsStackView.addArrangedSubview(star)
            }
        case 4..<6:
            for _ in 1...2 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
            for _ in 1...3 {
                let star = UIImageView(image: UIImage(named: "star"))
                starsStackView.addArrangedSubview(star)
            }
        case 6..<8:
            for _ in 1...3 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
            for _ in 1...2 {
                let star = UIImageView(image: UIImage(named: "star"))
                starsStackView.addArrangedSubview(star)
            }
        case 8..<10:
            for _ in 1...4 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
            let star = UIImageView(image: UIImage(named: "star"))
            starsStackView.addArrangedSubview(star)
        case 5...:
            for _ in 1...5 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
        default:
            return
        }
    }
}
