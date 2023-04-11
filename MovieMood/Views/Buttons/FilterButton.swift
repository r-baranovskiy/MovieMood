//
//  FilterButton.swift
//  MovieMood
//
//  Created by Дмитрий on 11.04.2023.
//

import UIKit

final class FilterButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        setImage(UIImage(named: "filter"), for: .normal)
        heightAnchor.constraint(equalToConstant: 13).isActive = true
        widthAnchor.constraint(equalToConstant: 13).isActive = true
    }
}
