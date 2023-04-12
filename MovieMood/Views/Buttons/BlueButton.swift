import UIKit

final class BlueButton: UIButton {
    
    enum ButtonStyle: String {
        case signUp = "Sign Up"
        case ation = "Action"
        case continueEmail = "Continue with Email"
        case saveChanges = "Save Changes"
        case logout = "Log Out"
        case change = "Change"
        case applyFilters = "Apply Filters"
    }
    
    private let style: ButtonStyle
    
    init(withStyle style: ButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitle(style.rawValue, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.custom.mainBlue
        layer.cornerRadius = 24
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        if style == .ation {
            layer.cornerRadius = 6
        }
        
        if style == .logout {
            setTitleColor(.custom.mainBlue, for: .normal)
            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = UIColor.custom.mainBlue.cgColor
        }
    }
}
