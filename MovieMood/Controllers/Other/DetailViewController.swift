import UIKit
import SDWebImage
import SafariServices

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mainScrollView = UIScrollView()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let movieNameLabel = UILabel(
        font: .systemFont(ofSize: 24, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    // Date
    private let dateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "calendar-icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dateLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Time
    private let timeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock-icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let durationLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )

    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Genre
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
    
    // Stars
    
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
    
    // Cast and Crew
    private let castAndCrewLabel = UILabel(
        font: .systemFont(ofSize: 16, weight: .semibold),
        textAlignment: .left, color: .label
    )
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collection.dataSource = self
        collection.backgroundColor = .none
        return collection
    }()
    
    // Button
    private lazy var watchButton: BlueButton = {
        let button = BlueButton(withStyle: .ation)
        button.setTitle("Watch now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 24
        button.addTarget(nil, action: #selector(loadYouTubeVideo), for: .touchUpInside)
        return button
    }()
    
    private let apiManager: ApiManagerProtocol = ApiManager(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
    private var detailMovie: MovieDetail?
    private var model: CastAndCrew?
    private var movieVideo: MovieVideoModel?
    private var cast: [Cast] = []
    private var crew: [Crew] = []
    private var rating: Double?
    private var videoID: String? = nil
    
    private let movieId: Int
    private var isFavorite: Bool
    private let currentUser: UserRealm
    
    init(movieId: Int, isFavorite: Bool, currentUser: UserRealm) {
        self.movieId = movieId
        self.isFavorite = isFavorite
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        configure(idMovie: movieId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.mainBackground
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "\(DetailCollectionViewCell.self)")
        title = "Movie Detail"
        //navigationItem.backBarButtonItem?.image = UIImage(named: "back-button-icon")
        navigationController?.navigationBar.backItem?.backBarButtonItem?.image = UIImage(named: "back-button-icon")
        setupUI()
    }
    
    func configure(idMovie: Int) {
        Task {
            detailMovie = try? await apiManager.fetchMovieDetail(with: idMovie)
            model = try? await apiManager.fetchCastAndCrew(with: idMovie)
            movieVideo = try? await apiManager.fetchMovieVideo(with: idMovie)
            await MainActor.run(body: {
                movieNameLabel.text = detailMovie?.title
                dateLabel.text = detailMovie?.release_date
                if let time = detailMovie?.runtime {
                    durationLabel.text = "\(time) Minutes"
                }
                if let name = detailMovie?.genres, !name.isEmpty {
                    genreLabel.text = name[0].name
                }
                textView.text = detailMovie?.overview
                rating = detailMovie?.vote_average
                if let poster = detailMovie?.poster_path {
                    movieImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(poster)"))
                }
                getStarsImage(with: rating ?? 0)
                
                if let movieId = movieVideo?.results, !movieId.isEmpty {
                    videoID = movieId[0].key
                }
                
                cast = model?.cast ?? []
                crew = model?.crew ?? []
                collectionView.reloadData()
            })
        }
    }
    
    @objc private func didTapBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func didTapLike() {
        if !RealmManager.shared.isLikedMovie(for: currentUser, with: movieId) {
            RealmManager.shared.saveMovie(
                for: currentUser, with: movieId, moviesType: .favorite
            ) { _ in
                print("Liked")
            }
        } else {
            RealmManager.shared.removeMovie(for: currentUser, with: movieId) { _ in
                print("Deleted")
            }
        }
        isFavorite.toggle()
        navigationItem.rightBarButtonItem?.tintColor = isFavorite ? .custom.mainBlue : .label
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
            let star1 = UIImageView(image: UIImage(named: "star1"))
            starsStackView.addArrangedSubview(star1)
            for _ in 1...4 {
                let star = UIImageView(image: UIImage(named: "star"))
                starsStackView.addArrangedSubview(star)
            }
        case 2..<4:
            for _ in 1...2 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
            for _ in 1...3 {
                let star = UIImageView(image: UIImage(named: "star"))
                starsStackView.addArrangedSubview(star)
            }
        case 4..<6:
            for _ in 1...3 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
            for _ in 1...2 {
                let star = UIImageView(image: UIImage(named: "star"))
                starsStackView.addArrangedSubview(star)
            }
        case 6..<8:
            for _ in 1...4 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
            let star = UIImageView(image: UIImage(named: "star"))
            starsStackView.addArrangedSubview(star)
        case 8...10:
            for _ in 1...5 {
                let star1 = UIImageView(image: UIImage(named: "star1"))
                starsStackView.addArrangedSubview(star1)
            }
        default:
            return
        }
    }
}

//MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DetailCollectionViewCell.self)", for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }

        if let poster = cast[indexPath.item].profile_path {
            cell.photoImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(poster)"))
        }
        cell.nameLabel.text = cast[indexPath.item].name
        cell.professionLabel.text = cast[indexPath.item].character
        return cell
    }
}

//MARK: - Setup UI
extension DetailViewController {
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "back-button-icon"),
            style: .done, target: self, action: #selector(didTapBack)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: isFavorite ? "heart-icon-fill" : "heart-icon"),
            style: .done, target: self, action: #selector(didTapLike))
        navigationItem.rightBarButtonItem?.tintColor = isFavorite ? .custom.mainBlue : .label
        
        dateStackView.addArrangedSubview(dateImageView)
        dateStackView.addArrangedSubview(dateLabel)
        
        timeStackView.addArrangedSubview(timeImageView)
        timeStackView.addArrangedSubview(durationLabel)
        
        genreStackView.addArrangedSubview(genreImageView)
        genreStackView.addArrangedSubview(genreLabel)
        
        horizontalInformationStack.addArrangedSubview(dateStackView)
        horizontalInformationStack.addArrangedSubview(timeStackView)
        horizontalInformationStack.addArrangedSubview(genreStackView)
        
        informationStackView.addArrangedSubview(movieNameLabel)
        informationStackView.addArrangedSubview(horizontalInformationStack)
        informationStackView.addArrangedSubview(starsStackView)
        
        view.addSubviewWithoutTranslates(mainScrollView)
    
        mainScrollView.addSubviewWithoutTranslates(
            movieImageView, informationStackView, storyLineLabel, textView,
            castAndCrewLabel, collectionView, watchButton
        )
        
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            movieImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 40),
            movieImageView.heightAnchor.constraint(equalToConstant: 300),
            movieImageView.widthAnchor.constraint(equalToConstant: 225),
            movieImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            informationStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 24),
            informationStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            informationStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            storyLineLabel.topAnchor.constraint(equalTo: informationStackView.bottomAnchor, constant: 30),
            storyLineLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            textView.topAnchor.constraint(equalTo: storyLineLabel.bottomAnchor, constant: 16),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            
            castAndCrewLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 24),
            castAndCrewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            
            collectionView.topAnchor.constraint(equalTo: castAndCrewLabel.bottomAnchor, constant: 16),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            watchButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 28),
            watchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchButton.widthAnchor.constraint(equalToConstant: 181),
            watchButton.heightAnchor.constraint(equalToConstant: 56),
            watchButton.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -20)
        ])
    }
}
