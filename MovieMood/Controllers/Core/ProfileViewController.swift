import UIKit

/// This class opens when user go to profile
final class ProfileViewController: UIViewController {
    
    private let titleLabel = CustomLabel(withText: "Profile", style: .title)
    private let profileImageView = ProfileImageView(UIImage(named: "mock-person")!)
    
    private let firstNameField = ProfileFieldView(style: .firstName, value: "Maxim")
    private let lastNameField = ProfileFieldView(style: .lastName, value: "Shantsev")
    private let emailField = ProfileFieldView(style: .email, value: "shantsev.m@ya.ru")
    private let genderSelector = ProfileGenderSelector()
    
    private let saveButton = BlueButton(withStyle: .saveChanges)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.mainBackground
        setupView()
    }
}

extension ProfileViewController {
    
    private func setupView() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        let stack = UIStackView(arrangedSubviews: [
            firstNameField, lastNameField, emailField
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(lessThanOrEqualTo: profileImageView.bottomAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        genderSelector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genderSelector)
        NSLayoutConstraint.activate([
            genderSelector.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16),
            genderSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            genderSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
        
//        genderMaleButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(genderMaleButton)
//        NSLayoutConstraint.activate([
//            genderMaleButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
//            genderMaleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            genderMaleButton.widthAnchor.constraint(equalToConstant: 156)
//        ])
//
    }
}
