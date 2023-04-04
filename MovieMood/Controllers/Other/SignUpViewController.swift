import UIKit

/// This class opens when user wants to register a new acc
final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(withText: "Sign Up", style: .title)
    private let completeLabel = CustomLabel(withText: "Complete your account", style: .head)
    private let subLabel = CustomLabel(withText: "Lorem ipsum dolor sit amet", style: .subHead)
    
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
                equalTo: view.topAnchor, constant: 71
            )
        ])
        
        view.addSubview(completeLabel)
        NSLayoutConstraint.activate([
            completeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 43
            )
        ])
        
        view.addSubview(subLabel)
        NSLayoutConstraint.activate([
            subLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subLabel.topAnchor.constraint(equalTo: completeLabel.bottomAnchor, constant: 8)
        ])
        
        let stack = UIStackView(arrangedSubviews: [
            emailTextField, firstNameTextField, lastNameTextField,
            passwordTextField, confirmPasswordTextField
        ])
        stack.axis = .vertical
        stack.spacing = 46
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                equalTo: subLabel.bottomAnchor, constant: 32
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

