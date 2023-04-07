import UIKit
import SDWebImage

final class ProfileViewController: UIViewController {
    
    enum PicturePickerType {
        case camera
        case photoLibrary
    }
    
    // MARK: - Properties
    
    private let currentUser: MovieUser
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
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
    
    // MARK: - Init
    
    init(user: MovieUser) {
        currentUser = user
        super.init(nibName: nil, bundle: nil)
        firstNameField.text = currentUser.firstName
        lastNameField.text = currentUser.lastName
        emailField.text = currentUser.email
        if let imageUrl = currentUser.avatarImageUrl {
            avatarImageView.sd_setImage(with: imageUrl)
        } else {
            avatarImageView.image = UIImage(named: "mock-person")
        }
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
        addRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
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
    
    private func addRecognizer() {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(recognizer)
    }
    
    private func avatarAlert() {
        let alert = UIAlertController(
            title: "Profile Picture", message: nil, preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "Cancel", style: .cancel)
        )
        alert.addAction(UIAlertAction(
            title: "Camera", style: .default, handler: { _ in
                DispatchQueue.main.async {
                    self.presentProfilePicturePicker(type: .camera)
                }
            })
        )
        alert.addAction(UIAlertAction(
            title: "Photo Library", style: .default, handler: { _ in
                DispatchQueue.main.async {
                    self.presentProfilePicturePicker(type: .photoLibrary)
                }
            })
        )
        present(alert, animated: true)
    }
    
    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapAvatar() {
        avatarAlert()
    }
    
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

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[
            UIImagePickerController.InfoKey.editedImage
        ] as? UIImage else {
            return
        }
        avatarImageView.image = image
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