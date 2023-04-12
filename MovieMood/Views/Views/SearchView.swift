//
//  SearchView.swift
//  MovieMood
//
//  Created by Дмитрий on 11.04.2023.
//

import UIKit

final class SearchView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        image = UIImage(named: "search")
        
        heightAnchor.constraint(equalToConstant: 16).isActive = true
        widthAnchor.constraint(equalToConstant: 16).isActive = true
    }
}
