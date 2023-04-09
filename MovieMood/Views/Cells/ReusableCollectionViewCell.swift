import UIKit

protocol ReusableCollectionViewCellDelegate: AnyObject {
    func didTapLike()
}

final class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    weak var delegate: ReusableCollectionViewCellDelegate?
    
    // MARK: - Properties
    
    private let movieImageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heart-icon"), for: .normal)
        return button
    }()
    
    private let movieNameLabel = UILabel(
        font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .left, color: .label, numberOfLines: 2
    )
    
    private let durationLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let creatingDateLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private let genreLabel = UILabel(
        font: .systemFont(ofSize: 10, weight: .bold),
        textAlignment: .center, color: .white
    )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieNameLabel.text = nil
        durationLabel.text = nil
        genreLabel.text = nil
    }
    
    func configure(url: URL?, movieName: String, duration: Int,
                   creatingDate: String, genre: String) {
        movieImageView.sd_setImage(with: url)
        movieNameLabel.text = movieName
        durationLabel.text = String(duration)
        creatingDateLabel.text = creatingDate
        genreLabel.text = genre
    }
    
    // MARK: - Setup Cell
    
    private func setupCell() {
        let descriptionView = createDesctiptionView()
        
        addSubviewWithoutTranslates(movieImageView, descriptionView)
        
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 24
            ),
            movieImageView.widthAnchor.constraint(
                equalTo: widthAnchor, multiplier: 1/3
            ),
            movieImageView.heightAnchor.constraint(
                equalTo: movieImageView.widthAnchor, multiplier: 1.33
            ),
            
            descriptionView.topAnchor.constraint(equalTo: topAnchor),
            descriptionView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -20
            ),
            descriptionView.leadingAnchor.constraint(
                equalTo: movieImageView.trailingAnchor, constant: 15
            ),
            descriptionView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -20
            )
        ])
    }
}

// MARK: - Genre View

extension MovieCollectionViewCell {
    private func createDesctiptionView() -> UIView {
        let view = UIView()
        
        let firstView = UIView()
        firstView.backgroundColor = .systemGreen
        firstView.addSubviewWithoutTranslates(movieNameLabel, likeButton)
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(
                equalTo: firstView.trailingAnchor
            ),
            likeButton.widthAnchor.constraint(equalToConstant: 22),
            likeButton.heightAnchor.constraint(equalToConstant: 20),
            likeButton.centerYAnchor.constraint(
                equalTo: firstView.centerYAnchor)
            ,
            
            movieNameLabel.leadingAnchor.constraint(
                equalTo: firstView.leadingAnchor
            ),
            movieNameLabel.trailingAnchor.constraint(
                equalTo: likeButton.leadingAnchor, constant: -20
            )
        ])
        
        let secondView = UIView()
        let durationImageView = UIImageView(image: UIImage(named: "clock-icon"))
        secondView.backgroundColor = .systemBlue
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
        let dateImageView = UIImageView(image: UIImage(named: "calendar-icon"))
        thirdView.backgroundColor = .orange
        thirdView.addSubviewWithoutTranslates(dateImageView, creatingDateLabel)
        NSLayoutConstraint.activate([
            dateImageView.topAnchor.constraint(
                equalTo: thirdView.topAnchor
            ),
            dateImageView.bottomAnchor.constraint(
                equalTo: thirdView.bottomAnchor
            ),
            dateImageView.leadingAnchor.constraint(
                equalTo: thirdView.leadingAnchor
            ),
            
            creatingDateLabel.leadingAnchor.constraint(
                equalTo: dateImageView.trailingAnchor, constant: 6
            ),
            creatingDateLabel.trailingAnchor.constraint(
                equalTo: thirdView.trailingAnchor
            )
        ])
        
        let fourthView = UIView()
        let genreView = createGenreView()
        let movieImageView = UIImageView(image: UIImage(named: "film-icon"))
        fourthView.backgroundColor = .systemYellow
        fourthView.addSubviewWithoutTranslates(movieImageView, genreView)
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(
                equalTo: fourthView.leadingAnchor
            ),
            
            movieImageView.centerYAnchor.constraint(
                equalTo: fourthView.centerYAnchor
            ),
            
            genreView.leadingAnchor.constraint(
                equalTo: movieImageView.trailingAnchor, constant: 6
            ),
            genreView.widthAnchor.constraint(equalToConstant: 65),
            genreView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        view.addSubviewWithoutTranslates(
            firstView, secondView, thirdView, fourthView
        )
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: view.topAnchor),
            firstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstView.heightAnchor.constraint(equalToConstant: 40),
            
            secondView.topAnchor.constraint(
                equalTo: firstView.bottomAnchor, constant: 12
            ),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            thirdView.topAnchor.constraint(
                equalTo: secondView.bottomAnchor, constant: 12
            ),
            thirdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thirdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            fourthView.topAnchor.constraint(
                equalTo: thirdView.bottomAnchor, constant: 12
            ),
            fourthView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fourthView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fourthView.heightAnchor.constraint(equalToConstant: 24)
        ])
        return view
    }
    
    private func createGenreView() -> UIView {
        let genreView = UIView()
        genreView.clipsToBounds = true
        genreView.backgroundColor = .custom.mainBlue
        genreView.layer.cornerRadius = 6
        
        genreView.addSubviewWithoutTranslates(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(
                equalTo: genreView.topAnchor, constant: 3
            ),
            genreLabel.bottomAnchor.constraint(
                equalTo: genreView.bottomAnchor, constant: -3
            ),
            genreLabel.leadingAnchor.constraint(
                equalTo: genreView.leadingAnchor, constant: 10
            ),
            genreLabel.trailingAnchor.constraint(
                equalTo: genreView.trailingAnchor, constant: -10
            )
        ])
        return genreView
    }
}
