import UIKit

/// This class opens when user wants to register a new acc
final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Sign Up"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Complete your acctount"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton = BlueButton(withStyle: .signUp)
    
    private let emailTextField = AuthTextField(forStyle: .email)
    private let firstNameTextField = AuthTextField(forStyle: .firstName)
    private let lastNameTextField = AuthTextField(forStyle: .lastName)
    private let passwordTextField = AuthTextField(forStyle: .password)
    private let confirmPasswordTextField = AuthTextField(forStyle: .confirmPassword)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custom.mainBackground
        setupView()
    }
}

extension SignUpViewController {
    private func setupView() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10
            )
        ])
        
        view.addSubview(completeLabel)
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
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
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

import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let listVC = SignUpViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) -> SignUpViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) {
        }
    }
}

