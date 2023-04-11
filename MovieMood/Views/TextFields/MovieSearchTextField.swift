//
//  MovieSearchTextField.swift
//  MovieMood
//
//  Created by Дмитрий on 10.04.2023.
//

import UIKit

final class MovieSearchTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 75)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Ovverade Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    //MARK: - Setup TextField
    private func setupTextField() {
        autocorrectionType = .no
        attributedPlaceholder = NSAttributedString(
            string: "Search movie", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.custom.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ])
        heightAnchor.constraint(equalToConstant: 52).isActive = true
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.custom.mainBlue.cgColor
        backgroundColor = .clear
    }
}
