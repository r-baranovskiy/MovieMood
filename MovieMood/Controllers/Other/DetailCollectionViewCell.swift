//
//  DetailCollectionViewCell.swift
//  MovieMood
//
//  Created by Дмитрий on 05.04.2023.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let professionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let subviews = [photoImageView, nameLabel, professionLabel]
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
            nameLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 8),
            
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            professionLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 8)
        ])
    }
}
