//
//  CategoryButton.swift
//  MovieMood
//
//  Created by Nikolai Zvonarev on 11.04.2023.
//

import UIKit

final class CategoryButton: UIButton {
    
    enum Category: String {
        case all = "All"
        case action = "Action"
        case adventure = "Adventure"
        case erotic = "Erotic"
        case exotic = "Exotic"
        case comedy = "Comedy"
        }
    
    let category: Category
    
    init(category: Category) {
        self.category = category
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
        
        setTitle(category.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        heightAnchor.constraint(equalToConstant: 32).isActive = true

        contentHorizontalAlignment = .center
        
    }
}
