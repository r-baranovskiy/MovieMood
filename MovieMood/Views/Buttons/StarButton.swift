//
//  StarButton.swift
//  MovieMood
//
//  Created by Nikolai Zvonarev on 11.04.2023.
//

import UIKit

final class StarButton: UIButton {
    
    enum Stars: String {
        case one = "⭐️"
        case two = "⭐️⭐️"
        case three = "⭐️⭐️⭐️"
        case four = "⭐️⭐️⭐️⭐️"
        case five = "⭐️⭐️⭐️⭐️⭐️"
        }
    let stars: Stars
    
    init(stars: Stars) {
        self.stars = stars
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.custom.mainBlue.cgColor
        
        setTitle(stars.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        heightAnchor.constraint(equalToConstant: 32).isActive = true

        contentHorizontalAlignment = .center
        
    }
}

