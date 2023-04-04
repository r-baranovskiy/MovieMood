//
//  ReusableCell.swift
//  MovieMood
//
//  Created by иван Бирюков on 04.04.2023.
//

import UIKit

class ReusableCell: UITableViewCell {
    
    var movie : Movie? {
        didSet{
            
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
        label.font = UIFont.systemFont(ofSize: 18)
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
        
        let durationStackView = UIStackView(arrangedSubviews: [timeIcon, durationLabel])
        durationStackView.axis = .horizontal
        durationStackView.distribution = .equalSpacing
        durationStackView.spacing = 5
        
        let ratingStackView = UIStackView(arrangedSubviews: [starIcon, ratingLabel, amountVoiteLabel])
        ratingStackView.axis = .horizontal
        ratingStackView.distribution = .equalSpacing
        
        let leftStackView = UIStackView(arrangedSubviews: [movieCategoryLabel, movieNameLabel, durationStackView])
        leftStackView.axis = .vertical
        leftStackView.distribution = .fillEqually
        
        let rightStackView = UIStackView(arrangedSubviews: [likeButton, ratingStackView])
        rightStackView.axis = .vertical
        rightStackView.distribution = .equalSpacing
        
        let mainStackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fill
        contentView.addSubview(mainStackView)
        
        
        movieImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 24, paddingBottom: 5, paddingRight: 0, width: 80, height: 80, enableInsets: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

