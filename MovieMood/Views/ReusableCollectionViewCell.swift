protocol ReusableCollectionViewCellDelegate: AnyObject {
    func didTapAction()
    func didTapLike()
}

import UIKit

class ReusableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReusableCollectionViewCell"
    
    weak var delegate: ReusableCollectionViewCellDelegate?
    
    var film : Movie? {
        didSet{
            movieImage.image = film?.movieImage
            movieNameLabel.text = film?.movieName
            durationLabel.text = film?.movieDuration
            creatingDateLabel.text = film?.dateCreating
        }
    }
    
    // MARK: - Creating UI elements
    
    private let movieImage : UIImageView = {
        let img = UIImageView(image: UIImage(named: "mock-film-four"))
        img.contentMode = .scaleToFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let movieNameLabel : UILabel = {
        let name = UILabel()
        name.text = "Jurasick Park"
        name.textColor = .black
        name.font = UIFont.boldSystemFont(ofSize: 26)
        name.textAlignment = .left
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let likeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heart-icon"), for: .normal)
        button.setTitle(nil, for: .normal)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    private let dateIcon : UIImageView = {
        let date = UIImageView(image: UIImage(named: "calendar-icon"))
        date.contentMode = .scaleToFill
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private let creatingDateLabel : UILabel = {
        let date = UILabel()
        date.text = "15 sempt 2021"
        date.textColor = .lightGray
        date.font = UIFont.systemFont(ofSize: 15)
        date.textAlignment = .left
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private let filmIcon : UIImageView = {
        let film = UIImageView(image: UIImage(named: "film-icon"))
        film.contentMode = .scaleToFill
        film.translatesAutoresizingMaskIntoConstraints = false
        return film
    }()
    
    private let actionButton : UIButton = {
        let btn =  BlueButton(withStyle: .ation)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
        
    // MARK: - Setting up UI
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)

        contentView.addSubview(movieImage)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(timeIcon)
        contentView.addSubview(durationLabel)
        contentView.addSubview(dateIcon)
        contentView.addSubview(creatingDateLabel)
        contentView.addSubview(filmIcon)
        contentView.addSubview(actionButton)
        
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieImage.widthAnchor.constraint(equalToConstant: 120),
            movieImage.heightAnchor.constraint(equalToConstant: 160),
            
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 14),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            
            timeIcon.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 12),
            timeIcon.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 14),
            timeIcon.widthAnchor.constraint(equalToConstant: 16),
            timeIcon.heightAnchor.constraint(equalToConstant: 16),
            
            durationLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 12),
            durationLabel.leadingAnchor.constraint(equalTo: timeIcon.trailingAnchor, constant: 4),
            
            dateIcon.topAnchor.constraint(equalTo: timeIcon.bottomAnchor, constant: 12),
            dateIcon.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 14),
            dateIcon.widthAnchor.constraint(equalToConstant: 16),
            dateIcon.heightAnchor.constraint(equalToConstant: 16),
            
            creatingDateLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 12),
            creatingDateLabel.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: 4),
            
            filmIcon.topAnchor.constraint(equalTo: dateIcon.bottomAnchor, constant: 12),
            filmIcon.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 14),
            
            actionButton.topAnchor.constraint(equalTo: dateIcon.bottomAnchor, constant: 12),
            actionButton.leadingAnchor.constraint(equalTo: filmIcon.trailingAnchor, constant: 4),
            actionButton.widthAnchor.constraint(equalToConstant: 65),
            actionButton.heightAnchor.constraint(equalToConstant: 24),
            

        ])
    }
    
    // MARK: - Buttons Methods
    
    @objc func actionButtonPressed() {
        delegate?.didTapAction()
    }
    
    @objc func likeButtonPressed() {
        delegate?.didTapLike()
        
        if likeButton.tag == 0 {
            likeButton.setImage(UIImage(named: "heart-icon-fill"), for: .normal)
            likeButton.tag = 1
        } else {
            likeButton.setImage(UIImage(named: "heart-icon"), for: .normal)
            likeButton.tag = 0
        }
    }
}
