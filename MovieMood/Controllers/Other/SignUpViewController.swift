import UIKit

/// This class opens when user wants to register a new acc
final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel(
        text: "Sign Up", font: .systemFont(ofSize: 18, weight: .semibold),
        textAlignment: .center, color: .label
    )
    
    private let completeLabel = UILabel(
        text: "Complete your account",
        font: .systemFont(ofSize: 24, weight: .semibold),
        textAlignment: .center, color: .label
    )
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "back-button-icon"),
                                  for: .normal)
        return button
    }()
    
    private let signUpButton = BlueButton(withStyle: .signUp)
    
    private let emailTextField = AppTextField(forStyle: .email)
    private let firstNameTextField = AppTextField(forStyle: .firstName)
    private let lastNameTextField = AppTextField(forStyle: .lastName)
    private let passwordTextField = AppTextField(forStyle: .password)
    private let confirmPasswordTextField = AppTextField(forStyle: .confirmPassword)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboardWhenTappedAround()
        keyboardSetting()
        addTargets()
    }
    
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didTapBack),
                             for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp),
                               for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapBack() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func didTapSignUp() {
        AuthManager.shared.createUser(
            email: emailTextField.text, password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text,
            firstName: firstNameTextField.text,
            lastName: lastNameTextField.text) { [weak self] result in
                switch result {
                case .success(let user):
                    let tabBar = MainTabBarController(user: user)
                    tabBar.modalTransitionStyle = .crossDissolve
                    tabBar.modalPresentationStyle = .fullScreen
                    self?.present(tabBar, animated: false)
                case .failure(let error):
                    let alert = UIAlertController.createAlert(
                        title: "Error", message: error.localizedDescription
                    )
                    self?.present(alert, animated: true)
                }
            }
    }
}

// MARK: - Keyboard Setting

extension SignUpViewController {
    private func keyboardSetting() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyBoardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(_ sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[
                UIResponder.keyboardFrameEndUserInfoKey
              ] as? NSValue,
              let currentTextField = UIResponder
            .currentFirst() as? UITextField else {
            return
        }
        
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(
            currentTextField.frame, from: currentTextField.superview
        )
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    @objc
    private func keyBoardWillHide(_ sender: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: - Setup View

extension SignUpViewController {
    private func setupView() {
        view.backgroundColor = .custom.mainBackground
        
        view.addSubviewWithoutTranslates(titleLabel, backButton, completeLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10
            )
        ])
        
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor, constant: 10
            ),
            backButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            )
        ])
        
        NSLayoutConstraint.activate([
            completeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 43
            )
        ])
        
        let stack = UIStackView(arrangedSubviews: [
            emailTextField, firstNameTextField, lastNameTextField,
            passwordTextField, confirmPasswordTextField, signUpButton
        ])
        stack.axis = .vertical
        stack.spacing = 25
        stack.distribution = .equalSpacing
        
        view.addSubviewWithoutTranslates(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                lessThanOrEqualTo: completeLabel.bottomAnchor, constant: 120
            ),
            stack.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10
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
