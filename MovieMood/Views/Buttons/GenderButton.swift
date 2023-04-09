import UIKit

final class GenderButton: UIButton {
    
    enum Gender: String {
        case male = "Male"
        case female = "Female"
    }
    
    private let sex: Gender
    
    init(sex: Gender) {
        self.sex = sex
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = .clear
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.custom.mainBlue.cgColor
        
        setTitle(sex.rawValue, for: .normal)
        setTitleColor(.label, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        heightAnchor.constraint(equalToConstant: 46).isActive = true
        setImage(UIImage(named: "check-on-icon")?
            .withTintColor(.custom.mainBlue), for: .selected)
        setImage(UIImage(named: "check-off-icon")?
            .withTintColor(.custom.mainBlue),for: .normal)

        contentHorizontalAlignment = .left
        titleEdgeInsets.left = 30
        imageEdgeInsets.left = 16
    }
}
