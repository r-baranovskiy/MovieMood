
// For best configurations RowHeight Should be set up to 90.

import UIKit

class ReusableCell: UITableViewCell {
    
    var movie : Movie? {    
        didSet{
            movieImage.image = movie?.movieImage
            movieCategoryLabel.text = movie?.movieCategory
            movieNameLabel.text = movie?.movieName
            durationLabel.text = movie?.movieDuration
            ratingLabel.text = "\(movie?.movieRating ?? 0.0)"
            amountVoiteLabel.text = "(\(movie?.movieRatingVoits ?? 0))"
        }
    }
    
    // MARK: - Creating UI elements
    
    private let movieImage : UIImageView = {
        let img = UIImageView(image: UIImage(named: "mock-film-four"))
        img.contentMode = .scaleToFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let movieCategoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Action"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heart-icon"), for: .normal)
        button.setTitle(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let movieNameLabel : UILabel = {
        let name = UILabel()
        name.text = "Jurasick Park"
        name.textColor = .black
        name.font = UIFont.boldSystemFont(ofSize: 24)
        name.textAlignment = .left
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let timeIcon : UIImageView = {
        let time = UIImageView(image: UIImage(named: "clock-icon"))
        time.contentMode = .scaleToFill
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    private let durationLabel : UILabel = {
        let duration = UILabel()
        duration.text = "148 minuts"
        duration.textColor = .lightGray
        duration.font = UIFont.systemFont(ofSize: 14)
        duration.textAlignment = .left
        duration.translatesAutoresizingMaskIntoConstraints = false
        return duration
    }()
    
    private let starIcon : UIImageView = {
        let star = UIImageView(image: UIImage(systemName: "star.fill"))
        star.tintColor = UIColor.CustomColor().goldColor
        star.contentMode = .scaleToFill
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }()
    
    private let ratingLabel : UILabel = {
        let rating = UILabel()
        rating.text = "4.4"
        rating.textColor = UIColor.CustomColor().goldColor
        rating.font = UIFont.systemFont(ofSize: 14)
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    private let amountVoiteLabel : UILabel = {
        let voites = UILabel()
        voites.text = "(52)"
        voites.textColor = .lightGray
        voites.font = UIFont.systemFont(ofSize: 14)
        voites.translatesAutoresizingMaskIntoConstraints = false
        return voites
    }()
    
   // MARK: - Setting up UI
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(movieImage)
        contentView.addSubview(movieCategoryLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(timeIcon)
        contentView.addSubview(durationLabel)
        contentView.addSubview(starIcon)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(amountVoiteLabel)
        
        setupContent()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            movieImage.heightAnchor.constraint(equalToConstant: 80),
            movieImage.widthAnchor.constraint(equalToConstant: 80),
            
            movieCategoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieCategoryLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 12),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            likeButton.heightAnchor.constraint(equalToConstant: 17),
            likeButton.widthAnchor.constraint(equalToConstant: 19),
            
            movieNameLabel.topAnchor.constraint(equalTo: movieCategoryLabel.bottomAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 12),
            
            timeIcon.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 9),
            timeIcon.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 12),
            timeIcon.widthAnchor.constraint(equalToConstant: 16),
            timeIcon.heightAnchor.constraint(equalToConstant: 15),
            
            durationLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 9),
            durationLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 5),
            
            amountVoiteLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 9),
            amountVoiteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 9),
            ratingLabel.trailingAnchor.constraint(equalTo: amountVoiteLabel.leadingAnchor, constant: -2),
            
            starIcon.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 9),
            starIcon.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -4),
            starIcon.heightAnchor.constraint(equalToConstant: 14),
            starIcon.widthAnchor.constraint(equalToConstant: 14),
        ])
    }
}
