import UIKit

struct Model {
    let photo: UIImage
    let name: String
    let prof: String
}

final class DetailViewController: UIViewController {
    
    let model = [Model(photo: UIImage(named: "mock-person") ?? UIImage(), name: "Bill", prof: "Director"),
                 Model(photo: UIImage(named: "mock-person") ?? UIImage(), name: "Bill", prof: "Director"),
                 Model(photo: UIImage(named: "mock-person") ?? UIImage(), name: "Bill", prof: "Director"),
                 Model(photo: UIImage(named: "mock-person") ?? UIImage(), name: "Bill", prof: "Director"),
                 Model(photo: UIImage(named: "mock-person") ?? UIImage(), name: "Bill", prof: "Director"),]

    private let mainView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        imageView.image = UIImage(named: "mock-film-two")
        return imageView
    }()
    
    private let nameMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        
        label.text = "Luck"
        return label
    }()
    
    // Date
    private let dateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "calendar-icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.471, green: 0.51, blue: 0.541, alpha: 1)
        
        label.text = "17 Sep 2021"
        return label
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Time
    private let timeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clock-icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.471, green: 0.51, blue: 0.541, alpha: 1)
        
        label.text = "148 minutes"
        return label
    }()
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    // Genre
    private let genreImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "film-icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.471, green: 0.51, blue: 0.541, alpha: 1)
        
        label.text = "Action"
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let horizontalInformationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    //
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .center
        return stackView
    }()
    
    // Story Line
    private let storyLineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "Story Line"
        return label
    }()
    
    private let textView: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 14)
        text.textColor = UIColor(red: 0.471, green: 0.51, blue: 0.541, alpha: 1)
        text.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Show More"
        text.numberOfLines = 0
        return text
    }()
    
    // Cast and Crew
    private let castAndCrewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "Cast and Crew"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collection.dataSource = self
        return collection
    }()
    
    // Button
    private let watchButton: BlueButton = {
        let button = BlueButton(withStyle: .ation)
        button.setTitle("Watch now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 24
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "\(DetailCollectionViewCell.self)")
        getStarsImage(with: 7.5)
        setupUI()
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
    
    private func setupUI() {
        dateStackView.addArrangedSubview(dateImageView)
        dateStackView.addArrangedSubview(dateLabel)
        
        timeStackView.addArrangedSubview(timeImageView)
        timeStackView.addArrangedSubview(timeLabel)
        
        genreStackView.addArrangedSubview(genreImageView)
        genreStackView.addArrangedSubview(genreLabel)
        
        horizontalInformationStack.addArrangedSubview(dateStackView)
        horizontalInformationStack.addArrangedSubview(timeStackView)
        horizontalInformationStack.addArrangedSubview(genreStackView)
        
        informationStackView.addArrangedSubview(nameMovieLabel)
        informationStackView.addArrangedSubview(horizontalInformationStack)
        informationStackView.addArrangedSubview(starsStackView)
        
        view.addSubview(mainView)
        
        let subviews = [movieImageView,
                        informationStackView,
                        storyLineLabel,
                        textView,
                        castAndCrewLabel,
                        collectionView,
                        watchButton]
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            movieImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 40),
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
            collectionView.heightAnchor.constraint(equalToConstant: 40),
            
            watchButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 28),
            watchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchButton.widthAnchor.constraint(equalToConstant: 181),
            watchButton.heightAnchor.constraint(equalToConstant: 56),
            watchButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20)
        ])
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DetailCollectionViewCell.self)", for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        cell.photoImageView.image = model[indexPath.item].photo
        cell.nameLabel.text = model[indexPath.item].name
        cell.professionLabel.text = model[indexPath.item].prof
        
        return cell
    }
}
