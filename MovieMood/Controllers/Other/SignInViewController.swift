import UIKit
import GoogleSignIn

/// This screen opens when user open the app after onboarding if it opens the app first time
final class SignInViewController: UIViewController {
    
    // MARK: - Propeties
    
    /// Containers
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.mainBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.mainBackground
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Labels
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Movie Mood"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In to your account"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orContinueLabel: UILabel = {
        let label = UILabel()
        label.text = "⎯⎯ or continue with ⎯⎯"
        label.textColor = .custom.lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// TextFields
    private let emailTextField = AuthTextField(forStyle: .email)
    private let passwordTextField = AuthTextField(forStyle: .password)
    
    /// Buttons
    private let continueButton = BlueButton(withStyle: .continueEmail)
    private let googleButton = GIDSignInButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.layer.cornerRadius = 30
    }
}

extension SignInViewController {
    private func setupView() {
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.70),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        topView.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 70),
            welcomeLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor)
        ])
        
        topView.addSubview(accountLabel)
        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: 50),
            accountLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor)
        ])
        
        googleButton.colorScheme = .dark
        googleButton.style = .wide
        googleButton.layer.cornerRadius = 8
        googleButton.clipsToBounds = true
        
        let stack = UIStackView(arrangedSubviews: [
            emailTextField, passwordTextField, continueButton,
            orContinueLabel, googleButton
        ])
        
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(stack)
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

import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let listVC = SignInViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) -> SignInViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) {
        }
    }
}

