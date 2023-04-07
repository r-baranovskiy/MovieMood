import UIKit

/// This class opens when user go to profile
final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let currentUser: MovieUser
        
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.image = UIImage(named: "mock-person")
        return imageView
    }()
    
    private let titleLabel = UILabel(
        text: "Profile", font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    /// Textfields
    private let firstNameField = AppTextField(forStyle: .firstName)
    private let lastNameField = AppTextField(forStyle: .lastName)
    private let emailField = AppTextField(forStyle: .email)
    
    /// Buttons
    private let saveButton = BlueButton(withStyle: .saveChanges)
    private let maleButton = GenderButton(sex: .male)
    private let femaleButton = GenderButton(sex: .female)
    
    init(user: MovieUser) {
        currentUser = user
        super.init(nibName: nil, bundle: nil)
        firstNameField.text = currentUser.firstName
        emailField.text = currentUser.email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maleButton.isSelected = true
        setupView()
        addTargets()
    }
    
    // MARK: - Behaviour
    
    private func addTargets() {
        maleButton.addTarget(self, action: #selector(didChangeGender(_:)),
                             for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(didChangeGender(_:)),
                               for: .touchUpInside)
        maleButton.tag = 0
        femaleButton.tag = 1
    }
    
    // MARK: - Actions
    
    @objc
    private func didChangeGender(_ sender: UIButton) {
        if sender.tag == 0 {
            maleButton.isSelected = true
            femaleButton.isSelected = false
        } else {
            femaleButton.isSelected = true
            maleButton.isSelected = false
        }
    }
}

// MARK: - Setup View

extension ProfileViewController {
    private func setupView() {
        view.backgroundColor = .custom.mainBackground
        let buttonStack = UIStackView(
            subviews: [maleButton, femaleButton], axis: .horizontal,
            spacing: 16, aligment: .fill, distribution: .fillEqually
        )
        
        let stack = UIStackView(
            subviews: [
                firstNameField, lastNameField, emailField,
                buttonStack, saveButton],
            axis: .vertical, spacing: 16, aligment: .fill,
            distribution: .equalSpacing
        )
        
        view.addSubviewWithoutTranslates(
            titleLabel, avatarImageView, stack
        )
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10
            )
        ])

        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(
                equalTo: titleLabel.topAnchor, constant: 48
            ),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                lessThanOrEqualTo: avatarImageView.bottomAnchor, constant: 16
            ),
            stack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            ),
            stack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -24
            )
        ])
    }
}
