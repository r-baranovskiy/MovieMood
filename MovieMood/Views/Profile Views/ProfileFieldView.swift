import UIKit

final class ProfileFieldView: UIView {
    
    enum ProfileFieldStyle: String {
        case firstName = "First Name"
        case lastName = "Last Name"
        case email = "E-mail"
    }
    
    private let fieldStyle: ProfileFieldStyle
    private let fieldValue: String
    
    private lazy var profileSubText = ProfileSubTextFiled(withText: fieldStyle.rawValue)
    private lazy var profileTextField = ProfileTextField(withPlaceholder: fieldStyle.rawValue, value: fieldValue)
    
    init(style: ProfileFieldStyle, value: String) {
        self.fieldStyle = style
        self.fieldValue = value
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(profileSubText)
        NSLayoutConstraint.activate([
            profileSubText.topAnchor.constraint(equalTo: topAnchor),
            profileSubText.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        addSubview(profileTextField)
        NSLayoutConstraint.activate([
            profileTextField.topAnchor.constraint(equalTo: profileSubText.bottomAnchor, constant: 8),
            profileTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: profileTextField.trailingAnchor),
            bottomAnchor.constraint(equalTo: profileTextField.bottomAnchor)
        ])
    }
    
}
