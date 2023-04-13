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
    
    
}
