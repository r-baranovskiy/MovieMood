import UIKit
import GoogleSignIn

/// This screen opens when user open the app after onboarding if it opens the app first time
final class SignInViewController: UIViewController {
    
    // MARK: - Propeties
    
    /// Containers
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.mainBlue
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.mainBackground
        view.layer.cornerRadius = 30
        return view
    }()
    
    /// Labels
    
    private let welcomeLabel = UILabel(
        text: "Welcome to Movie Mood",
        font: .systemFont(ofSize: 24, weight: .bold),
        textAlignment: .center, color: .label
    )
    
    private let accountLabel = UILabel(
        text: "Log In to your account",
        font: .systemFont(ofSize: 16, weight: .semibold),
        textAlignment: .center, color: .label
    )
    
    private let continueWithLabel = UILabel(
        text: "⎯⎯ or continue with ⎯⎯",
        font: .systemFont(ofSize: 14, weight: .semibold),
        textAlignment: .center, color: .custom.lightGray
    )
    
    /// TextFields
    private let emailTextField = AppTextField(forStyle: .email)
    private let passwordTextField = AppTextField(forStyle: .password)
    
    /// Buttons
    private let continueButton = BlueButton(withStyle: .continueEmail)
    private let googleButton = GoogleButton(type: .system)
    private let dontHaveAccButton = DontHaveAccButton(type: .system)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboardWhenTappedAround()
        keyboardSetting()
        addTargets()
    }
    
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        if (traitCollection.hasDifferentColorAppearance(
            comparedTo: previousTraitCollection)
        ) {
            googleButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.layer.cornerRadius = 30
    }
    
    private func addTargets() {
        continueButton.addTarget(self, action: #selector(didTapContinue),
                                 for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(didTapGoogle),
                               for: .touchUpInside)
        dontHaveAccButton.addTarget(self, action: #selector(didTapDontHaveAcc),
                                    for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapContinue() {
        AuthManager.shared.loginWithEmail(
            email: emailTextField.text,
            password: passwordTextField.text) { [weak self] result in
                switch result {
                case .success(let user):
                    let tabBar = MainTabBarController(user: user)
                    tabBar.modalTransitionStyle = .crossDissolve
                    tabBar.modalPresentationStyle = .fullScreen
                    self?.present(tabBar, animated: true)
                case .failure(let error):
                    let alert = UIAlertController.createAlert(
                        title: "Error", message: error.localizedDescription
                    )
                    self?.present(alert, animated: true)
                }
            }
    }
    
    @objc
    private func didTapGoogle() {
        AuthManager.shared.loginWithGoogle(viewController: self)
        { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    let tabBar = MainTabBarController(user: user)
                    tabBar.modalTransitionStyle = .crossDissolve
                    tabBar.modalPresentationStyle = .fullScreen
                    self?.present(tabBar, animated: true)
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
    private func didTapDontHaveAcc() {
        let signUpVC = SignUpViewController()
        signUpVC.modalTransitionStyle = .crossDissolve
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true)
    }
}

// MARK: - Keyboard Setting

extension SignInViewController {
    private func keyboardSetting() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(
//            self, selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification, object: nil
//        )
//        notificationCenter.addObserver(
//            self, selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification, object: nil
//        )
    }
}

// MARK: - Setup View

extension SignInViewController {
    private func setupView() {
        
        view.addSubviewWithoutTranslates(topView, bottomView)
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.70
            ),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.bottomAnchor.constraint(
                equalTo: bottomView.bottomAnchor, constant: -30
            ),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        topView.addSubviewWithoutTranslates(welcomeLabel, accountLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(
                equalTo: topView.topAnchor, constant: 70
            ),
            welcomeLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(
                equalTo: welcomeLabel.topAnchor, constant: 50
            ),
            accountLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor)
        ])
        
        let stack = UIStackView(arrangedSubviews: [
            emailTextField, passwordTextField, continueButton,
            continueWithLabel, googleButton, dontHaveAccButton
        ])
        
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubviewWithoutTranslates(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                equalTo: bottomView.topAnchor, constant: 70
            ),
            stack.leadingAnchor.constraint(
                equalTo: bottomView.leadingAnchor, constant: 24
            ),
            stack.trailingAnchor.constraint(
                equalTo: bottomView.trailingAnchor, constant: -24
            )
        ])
    }
}
