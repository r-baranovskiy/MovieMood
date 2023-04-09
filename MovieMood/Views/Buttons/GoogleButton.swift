import UIKit

final class GoogleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupButton() {
        backgroundColor = .clear
        setTitle("Continue with Google", for: .normal)
        setTitleColor(.label, for: .normal)
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        
        let googleImageView = UIImageView(image: UIImage(named: "GoogleIcon"))
        addSubviewWithoutTranslates(googleImageView)
        
        NSLayoutConstraint.activate([
            googleImageView.heightAnchor.constraint(equalToConstant: 24),
            googleImageView.widthAnchor.constraint(equalToConstant: 24),
            googleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            googleImageView.trailingAnchor.constraint(
                equalTo: titleLabel!.leadingAnchor, constant: -12
            )
        ])
    }
}
