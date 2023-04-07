import UIKit

final class ProfileTextField: UITextField {
    
    private let fieldPlaceholder: String
    private let fieldValue: String
    
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 66)
    
    init(withPlaceholder text: String, value: String) {
        self.fieldPlaceholder = text
        self.fieldValue = value
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
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        attributedPlaceholder = NSAttributedString(
            string: fieldPlaceholder, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.custom.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16,
                                                               weight: .regular)
            ])
        heightAnchor.constraint(equalToConstant: 52).isActive = true
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.custom.mainBlue.cgColor
        text = fieldValue
    }
}
