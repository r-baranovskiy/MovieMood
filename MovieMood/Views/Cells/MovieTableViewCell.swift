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
                   genre: String, votesAmoutCount: Int, rate: Double) {
        isFavorite = true
        movieImageView.sd_setImage(with: url)
        movieNameLabel.text = movieName
        durationLabel.text = String(duration)
        genreLabel.text = genre
        ratingLabel.text = String(rate)
        votesAmountLabel.text = "(\(votesAmoutCount))"
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
        
        let firstView = UIView()
        firstView.addSubviewWithoutTranslates(genreLabel, likeButton)
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(
                equalTo: firstView.trailingAnchor
            ),
            likeButton.widthAnchor.constraint(equalToConstant: 22),
            likeButton.heightAnchor.constraint(equalToConstant: 20),
            likeButton.centerYAnchor.constraint(
                equalTo: firstView.centerYAnchor)
            ,
            
            genreLabel.leadingAnchor.constraint(
                equalTo: firstView.leadingAnchor
            ),
            genreLabel.trailingAnchor.constraint(
                equalTo: likeButton.leadingAnchor, constant: -20
            )
        ])
        
        let secondView = UIView()
        let durationImageView = UIImageView(image: UIImage(named: "clock-icon"))
        secondView.addSubviewWithoutTranslates(durationImageView, durationLabel)
        NSLayoutConstraint.activate([
            durationImageView.topAnchor.constraint(
                equalTo: secondView.topAnchor
            ),
            durationImageView.bottomAnchor.constraint(
                equalTo: secondView.bottomAnchor
            ),
            durationImageView.leadingAnchor.constraint(
                equalTo: secondView.leadingAnchor
            ),
            
            durationLabel.leadingAnchor.constraint(
                equalTo: durationImageView.trailingAnchor, constant: 6
            ),
            durationLabel.trailingAnchor.constraint(
                equalTo: secondView.trailingAnchor
            )
        ])
        
        let thirdView = UIView()
        let starImageView = UIImageView(image: UIImage(named: "star.fill")?
            .withTintColor(.custom.goldColor))
        
        thirdView.addSubviewWithoutTranslates(
            starImageView, ratingLabel, votesAmountLabel
        )
        NSLayoutConstraint.activate([
            votesAmountLabel.trailingAnchor.constraint(
                equalTo: thirdView.trailingAnchor
            ),
            ratingLabel.trailingAnchor.constraint(
                equalTo: votesAmountLabel.leadingAnchor
            ),
            starImageView.trailingAnchor.constraint(
                equalTo: ratingLabel.leadingAnchor, constant: -5
            ),
            starImageView.heightAnchor.constraint(equalToConstant: 12),
            starImageView.widthAnchor.constraint(equalToConstant: 12)
        ])
        
        view.addSubviewWithoutTranslates(
            firstView, movieNameLabel, secondView, thirdView
        )
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstView.heightAnchor.constraint(equalToConstant: 15),
            
            movieNameLabel.topAnchor.constraint(
                equalTo: firstView.bottomAnchor, constant: 6
            ),
            movieNameLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            movieNameLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -30
            ),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            secondView.topAnchor.constraint(
                equalTo: movieNameLabel.bottomAnchor, constant: 10
            ),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondView.widthAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: 2/3
            ),
            
            thirdView.centerYAnchor.constraint(equalTo: secondView.centerYAnchor),
            thirdView.leadingAnchor.constraint(
                equalTo: secondView.trailingAnchor
            ),
            thirdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return view
    }
}
