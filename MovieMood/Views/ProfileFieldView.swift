import UIKit

enum ProfileFieldStyle: String {
    case firstName = "First Name"
    case lastName = "Last Name"
    case email = "E-mail"
    case dateBirth = "Date of Birth"
}

final class ProfileFieldView: UIView {
    
    private let fieldStyle: ProfileFieldStyle
    
    private lazy var profileSubText = ProfileSubTextFiled(style: fieldStyle)
    private lazy var profileTextField = ProfileTextField(forStyle: fieldStyle)
    
    init(style: ProfileFieldStyle) {
        self.fieldStyle = style
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
