import UIKit

final class ProfileGenderSelector: UIView {
    
    private var sex: String = "Male"
    
    private lazy var profileSubText = ProfileSubTextFiled(withText: "Gender")
    
    private lazy var genderMaleButton = ProfileGenderButton(withStyle: .male, isOn: true)
    private lazy var genderFemaleButton = ProfileGenderButton(withStyle: .female)
    
    private let genderStack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func maleButtonPressed() {
        genderMaleButton.setupCheck(status: true)
        genderFemaleButton.setupCheck(status: false)
    }
    
    @objc private func femaleButtonPressed() {
        genderFemaleButton.setupCheck(status: true)
        genderMaleButton.setupCheck(status: false)
    }
    
    private func configure() {
        genderMaleButton.addTarget(self, action: #selector(maleButtonPressed), for: .touchUpInside)
        genderFemaleButton.addTarget(self, action: #selector(femaleButtonPressed), for: .touchUpInside)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(profileSubText)
        NSLayoutConstraint.activate([
            profileSubText.topAnchor.constraint(equalTo: topAnchor),
            profileSubText.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        genderStack.addArrangedSubview(genderMaleButton)
        genderStack.addArrangedSubview(genderFemaleButton)
        addSubview(genderStack)
        NSLayoutConstraint.activate([
            genderStack.topAnchor.constraint(equalTo: profileSubText.bottomAnchor, constant: 8),
            genderStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: genderStack.trailingAnchor),
            bottomAnchor.constraint(equalTo: genderStack.bottomAnchor)
        ])
    }
    
}
