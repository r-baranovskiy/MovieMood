//
//  CustomLabel.swift
//  MovieMood
//
//  Created by User on 04.04.2023.
//

import UIKit

final class CustomLabel: UILabel {
    
    enum LabelStyle: String {
        case title
        case head
        case subHead
    }
    
    private let textLabel: String
    private let styleLabel: LabelStyle
    
    init(withText text: String, style: LabelStyle) {
        self.textLabel = text
        self.styleLabel = style
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        if styleLabel == .title {
            translatesAutoresizingMaskIntoConstraints = false
            text = textLabel
            numberOfLines = 0
            textAlignment = .center
            textColor = .black
            font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        if styleLabel == .head {
            translatesAutoresizingMaskIntoConstraints = false
            text = textLabel
            numberOfLines = 0
            textAlignment = .center
            textColor = .black
            font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        }
        
        if styleLabel == .subHead {
            translatesAutoresizingMaskIntoConstraints = false
            text = textLabel
            numberOfLines = 0
            textAlignment = .center
            textColor = .gray
            font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
}
