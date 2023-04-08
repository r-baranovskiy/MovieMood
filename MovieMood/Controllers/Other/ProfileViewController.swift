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
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let blur = UIVisualEffectView(effect: effect)
        return blur
    }()
    
    /// Textfields
    private let firstNameField = AppTextField(forStyle: .firstName)
    private let lastNameField = AppTextField(forStyle: .lastName)
    private let emailField = AppTextField(forStyle: .email)
    
    /// Buttons
    private let saveButton = BlueButton(withStyle: .saveChanges)
    private let maleButton = GenderButton(sex: .male)
    private let femaleButton = GenderButton(sex: .female)
    private let testButton = BlueButton(withStyle: .ation)
    
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
        testButton.addTarget(self, action: #selector(didTapTest), for: .touchUpInside)
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
    
    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapTest() {
        let vc = ChangePasswordViewController()
        present(vc, animated: true)
    }
    
    @objc
    private func didTapAvatar() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.showPhotoPickerView()
            }
        }
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

// MARK: - PhotoPickerViewDelegate

extension ProfileViewController: PhotoPickerViewDelegate {
    func didChangePhotoAlbum() {
        presentProfilePicturePicker(type: .photoLibrary)
    }
    
    func didChangeCamera() {
        presentProfilePicturePicker(type: .camera)
    }
    
    func didChangeDelete() {
        print("Delete")
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

// MARK: - Setup BlurView

extension ProfileViewController {
    private func showPhotoPickerView() {
        let pickerView = PhotoPickerView()
        pickerView.delegate = self
        view.addSubviewWithoutTranslates(blurView)
        blurView.contentView.addSubviewWithoutTranslates(pickerView)
                
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pickerView.centerYAnchor.constraint(
                equalTo: blurView.centerYAnchor
            ),
            pickerView.heightAnchor.constraint(
                equalTo: blurView.heightAnchor, multiplier: 1.4/3
            ),
            pickerView.leadingAnchor.constraint(
                equalTo: blurView.leadingAnchor, constant: 24
            ),
            pickerView.trailingAnchor.constraint(
                equalTo: blurView.trailingAnchor, constant: -24
            ),
        ])
        
        updateViewConstraints()
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
                buttonStack, saveButton, testButton],
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
