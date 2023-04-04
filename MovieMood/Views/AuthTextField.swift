import UIKit

final class AuthTextField: UITextField {
    
    /// Textfield style that must choise when init this textfield
    enum TextFieldStyle: String {
        case email = "Email address"
        case firstName = "First Name"
        case lastName = "Last Name"
        case password = "Password"
        case confirmPassword = "Confirm password"
    }
    
    // MARK: - Properties
    
    /// Textfield type that need init
    private let fieldStyle: TextFieldStyle
    
    /// Insets from figma design
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 66)
    
    private var isPrivatePassword = true
    
    private var rightPasswordImage: UIImage? {
        return isShowPassword ? UIImage(named: "Eye") : UIImage(named: "EyeClose")
    }
    
    private var isShowPassword = true
    
    // MARK: - Observed properties
    
    /// Observed property that should change appearance textfield when user enter wrong password
    var wrongPassword = false {
        didSet {
            if wrongPassword {
                HapticsManager.shared.vibrate(for: .error)
                layer.borderColor = UIColor.systemRed.cgColor
                layer.borderWidth = 1
            }
        }
    }
    
    // MARK: - Init
    
    init(forStyle style: TextFieldStyle) {
        self .fieldStyle = style
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    /// Add Insets between entered text in textfield frame
    /// - Parameter bounds: Insert sizes
    /// - Returns: return necessary insert size
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    /// Add Insets between placeholder text in textfield frame
    /// - Parameter bounds: Insert sizes
    /// - Returns: return necessary insert size
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    /// Add Insets between editin text text in textfield frame
    /// - Parameter bounds: Insert sizes
    /// - Returns: return necessary insert size
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    @objc
    private func didTapShowPassword() {
        let imageName = isPrivatePassword
    }
    
    /// Configure custom text field
    private func configure() {
        attributedPlaceholder = NSAttributedString(
            string: fieldStyle.rawValue, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.custom.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16,
                                                               weight: .regular)
            ])
        layer.cornerRadius = 24
        
        if fieldStyle == .password || fieldStyle == .confirmPassword {
            isSecureTextEntry = isPrivatePassword
            let showPasswordButton = UIButton(type: .system)
            showPasswordButton.setBackgroundImage(rightPasswordImage, for: .normal)
            showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
            addSubview(showPasswordButton)
            showPasswordButton.addTarget(self,
                                         action: #selector(didTapShowPassword),
                                         for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                showPasswordButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                showPasswordButton.trailingAnchor.constraint(
                    equalTo: trailingAnchor, constant: -8)
            ])
        }
    }
}
