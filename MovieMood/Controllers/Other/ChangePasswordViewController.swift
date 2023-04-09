import UIKit

final class ChangePasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    /// TextFields
    private let passwordTextField = AppTextField(forStyle: .password)
    private let newPasswordTextField = AppTextField(forStyle: .newPassword)
    private let confirmTextField = AppTextField(forStyle: .confirmPassword)
    
    private let logOutButton = BlueButton(withStyle: .logout)
    private let changeButton = BlueButton(withStyle: .change)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addTargets()
    }
    
    // MARK: - Behaviour
    
    private func addTargets() {
        logOutButton.addTarget(self, action: #selector(didTapLogOut),
                               for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(didTapChange),
                               for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapLogOut() {
        AuthManager.shared.logOut { [weak self] result in
            switch result {
            case .success(let success):
                if success {
                    let signInVC = SignInViewController()
                    signInVC.modalTransitionStyle = .crossDissolve
                    signInVC.modalPresentationStyle = .fullScreen
                    self?.present(signInVC, animated: true)
                }
            case .failure(let error):
                let alert = UIAlertController.createAlert(
                    title: "Error", message: error.localizedDescription
                )
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc
    private func didTapChange() {
        AuthManager.shared.changePassword(
            password: passwordTextField.text,
            newPassword: newPasswordTextField.text,
            confirmPassword: confirmTextField.text) { [weak self] result in
                switch result {
                case .success:
                    let alert = UIAlertController.createAlert(
                        title: "Success",
                        message: "The password has been changed"
                    )
                    self?.present(alert, animated: true)
                case .failure(let error):
                    let alert = UIAlertController.createAlert(
                        title: "Error", message: error.localizedDescription
                    )
                    self?.present(alert, animated: true)
                }
            }
        passwordTextField.text = nil
        newPasswordTextField.text = nil
        confirmTextField.text = nil
    }
}

// MARK: - Setup View

extension ChangePasswordViewController {
    private func setupView() {
        view.backgroundColor = .custom.mainBackground
        
        let stack = UIStackView(
            subviews: [
                passwordTextField, newPasswordTextField, confirmTextField,
                changeButton, logOutButton
            ],
            axis: .vertical, spacing: 16, aligment: .fill,
            distribution: .equalSpacing
        )
        
        view.addSubviewWithoutTranslates(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20
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
