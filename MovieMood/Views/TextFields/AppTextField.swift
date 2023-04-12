import UIKit

final class AppTextField: UITextField {
    
    /// Textfield style that must choise when init this textfield
    enum TextFieldStyle: String {
        case email = "Email address"
        case firstName = "First Name"
        case lastName = "Last Name"
        case password = "Password"
        case confirmPassword = "Confirm password"
        case newPassword = "New password"
    }
    
    // MARK: - Properties
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(rightPasswordImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Textfield type that need init
    private let fieldStyle: TextFieldStyle
    
    /// Insets from figma design
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 66)
        
    private var rightPasswordImage: UIImage? {
        return isShowPassword ? UIImage(named: "Eye") : UIImage(named: "EyeClose")
    }
    
    private var isShowPassword = false {
        didSet {
            isSecureTextEntry.toggle()
            showPasswordButton.setBackgroundImage(rightPasswordImage, for: .normal)
        }
    }
    
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
        isShowPassword.toggle()
    }
    
    /// Configure custom text field
    private func configure() {
        autocorrectionType = .no
        autocapitalizationType = .none
        
        attributedPlaceholder = NSAttributedString(
            string: fieldStyle.rawValue, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.custom.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16,
                                                               weight: .regular)
            ])
        heightAnchor.constraint(equalToConstant: 52).isActive = true
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.custom.lightGray.cgColor
        
        if fieldStyle == .password || fieldStyle == .confirmPassword
            || fieldStyle == .newPassword {
            isSecureTextEntry = !isShowPassword
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
