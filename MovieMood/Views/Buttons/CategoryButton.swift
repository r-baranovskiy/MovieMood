import UIKit

final class CategoryButton: UIButton {
    
    enum Category: String {
        case tv = "TV"
        case all = "All"
        case horror = "Horror"
        case action = "Action"
        case adventure = "Adventure"
        case mystery = "Mystery"
        case fantasy = "Fantasy"
        case comedy = "Comedy"
    }
    
    private let category: Category
    
    init(category: Category) {
        self.category = category
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = .clear
        layer.cornerRadius = intrinsicContentSize.width / 1.5
        layer.borderWidth = 1
        layer.borderColor = UIColor.custom.mainBlue.cgColor
        
        setTitle(category.rawValue, for: .normal)
        setTitleColor(.label, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        heightAnchor.constraint(equalToConstant: 39).isActive = true
        
        contentHorizontalAlignment = .center
        
        if category == .all {
            isSelected = true
            backgroundColor = .custom.mainBlue
        }
    }
}
