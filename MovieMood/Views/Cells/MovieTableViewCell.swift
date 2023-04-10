import UIKit

protocol ReusableCellDelegate: AnyObject {
    func didTapFavorite()
}

final class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "MovieTableViewCell"
    
    weak var delegate: ReusableCellDelegate?
    
    // MARK: - Propeties
    
    private var isFavorite: Bool = false {
        didSet {
            let image = UIImage(named: isFavorite ? "heart-icon-fill" : "heart-icon")
            likeButton.setBackgroundImage(image, for: .normal)
        }
    }
    
    private let movieImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let genreLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let movieNameLabel = UILabel(
        font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .left, color: .label, numberOfLines: 2
    )
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heart-icon"), for: .normal)
        return button
    }()
    
    private let durationLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
//
//    private let starIcon : UIImageView = {
//        let star = UIImageView(image: UIImage(systemName: "star.fill"))
//        star.tintColor = UIColor.CustomColor().goldColor
//        star.contentMode = .scaleToFill
//        star.translatesAutoresizingMaskIntoConstraints = false
//        return star
//    }()
    
    private let ratingLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .semibold),
        textAlignment: .left, color: .custom.goldColor
    )
    
    private let votesAmountLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .semibold),
        textAlignment: .left, color: .custom.lightGray
    )
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        genreLabel.text = nil
        movieNameLabel.text = nil
        durationLabel.text = nil
        votesAmountLabel.text = nil
    }
    
    func configure(url: URL?, movieName: String, duration: Int,
                   genre: String, votesAmoutCount: Int) {
        isFavorite = true
        movieImageView.sd_setImage(with: url)
        movieNameLabel.text = movieName
        durationLabel.text = String(duration)
        genreLabel.text = genre
        votesAmountLabel.text = String(votesAmoutCount)
    }
    
    // MARK: - Setup Content View
    
    private func setupViewContent() {
        let descriptionView = createDesctiptionView()
        
        addSubviewWithoutTranslates(movieImageView, descriptionView)
        
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 24
            ),
            movieImageView.widthAnchor.constraint(
                equalToConstant: 80
            ),
            movieImageView.heightAnchor.constraint(
                equalTo: movieImageView.widthAnchor
            ),
            movieImageView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            
            descriptionView.topAnchor.constraint(
                equalTo: topAnchor, constant: 10
            ),
            descriptionView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -10
            ),
            descriptionView.leadingAnchor.constraint(
                equalTo: movieImageView.trailingAnchor, constant: 12
            ),
            descriptionView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -20
            )
        ])
    }
}

extension MovieTableViewCell {
    private func createDesctiptionView() -> UIView {
        selectionStyle = .none
        
        let view = UIView()
        
//        let firstView = UIView()
//        firstView.addSubviewWithoutTranslates(movieNameLabel, likeButton)
//        NSLayoutConstraint.activate([
//            likeButton.trailingAnchor.constraint(
//                equalTo: firstView.trailingAnchor
//            ),
//            likeButton.widthAnchor.constraint(equalToConstant: 22),
//            likeButton.heightAnchor.constraint(equalToConstant: 20),
//            likeButton.centerYAnchor.constraint(
//                equalTo: firstView.centerYAnchor)
//            ,
//
//            movieNameLabel.leadingAnchor.constraint(
//                equalTo: firstView.leadingAnchor
//            ),
//            movieNameLabel.trailingAnchor.constraint(
//                equalTo: likeButton.leadingAnchor, constant: -20
//            )
//        ])
//
//        let secondView = UIView()
//        let durationImageView = UIImageView(image: UIImage(named: "clock-icon"))
//        secondView.addSubviewWithoutTranslates(durationImageView, durationLabel)
//        NSLayoutConstraint.activate([
//            durationImageView.topAnchor.constraint(
//                equalTo: secondView.topAnchor
//            ),
//            durationImageView.bottomAnchor.constraint(
//                equalTo: secondView.bottomAnchor
//            ),
//            durationImageView.leadingAnchor.constraint(
//                equalTo: secondView.leadingAnchor
//            ),
//
//            durationLabel.leadingAnchor.constraint(
//                equalTo: durationImageView.trailingAnchor, constant: 6
//            ),
//            durationLabel.trailingAnchor.constraint(
//                equalTo: secondView.trailingAnchor
//            )
//        ])
//
//        let thirdView = UIView()
//        let dateImageView = UIImageView(image: UIImage(named: "calendar-icon"))
//        thirdView.addSubviewWithoutTranslates(dateImageView, creatingDateLabel)
//        NSLayoutConstraint.activate([
//            dateImageView.topAnchor.constraint(
//                equalTo: thirdView.topAnchor
//            ),
//            dateImageView.bottomAnchor.constraint(
//                equalTo: thirdView.bottomAnchor
//            ),
//            dateImageView.leadingAnchor.constraint(
//                equalTo: thirdView.leadingAnchor
//            ),
//
//            creatingDateLabel.leadingAnchor.constraint(
//                equalTo: dateImageView.trailingAnchor, constant: 6
//            ),
//            creatingDateLabel.trailingAnchor.constraint(
//                equalTo: thirdView.trailingAnchor
//            )
//        ])
//
//        let fourthView = UIView()
//        let genreView = createGenreView()
//        let movieImageView = UIImageView(image: UIImage(named: "film-icon"))
//        fourthView.addSubviewWithoutTranslates(movieImageView, genreView)
//        NSLayoutConstraint.activate([
//            movieImageView.leadingAnchor.constraint(
//                equalTo: fourthView.leadingAnchor
//            ),
//
//            movieImageView.centerYAnchor.constraint(
//                equalTo: fourthView.centerYAnchor
//            ),
//
//            genreView.leadingAnchor.constraint(
//                equalTo: movieImageView.trailingAnchor, constant: 6
//            ),
//            genreView.widthAnchor.constraint(equalToConstant: 65),
//            genreView.heightAnchor.constraint(equalToConstant: 24),
//        ])
//
//        view.addSubviewWithoutTranslates(
//            firstView, secondView, thirdView, fourthView
//        )
//        NSLayoutConstraint.activate([
//            firstView.topAnchor.constraint(equalTo: view.topAnchor),
//            firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            firstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            firstView.heightAnchor.constraint(equalToConstant: 40),
//
//            secondView.topAnchor.constraint(
//                equalTo: firstView.bottomAnchor, constant: 12
//            ),
//            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            thirdView.topAnchor.constraint(
//                equalTo: secondView.bottomAnchor, constant: 12
//            ),
//            thirdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            thirdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            fourthView.topAnchor.constraint(
//                equalTo: thirdView.bottomAnchor, constant: 12
//            ),
//            fourthView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            fourthView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            fourthView.heightAnchor.constraint(equalToConstant: 24)
//        ])
        return view
    }
}
