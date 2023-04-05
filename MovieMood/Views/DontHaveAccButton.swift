import UIKit

final class DontHaveAccButton: UIButton {
    
    private let title = "Don't have an account? "
    private let subtitle = "Sign Up"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        let attributedTitle = NSMutableAttributedString(
            string: title, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.label
            ]
        )
        attributedTitle.append(NSAttributedString(
            string: subtitle, attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.systemBlue
            ]
        ))
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
