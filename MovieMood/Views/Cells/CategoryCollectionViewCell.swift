import UIKit

struct CategoryCellViewModel {
    let title: String
    var isSelected: Bool
    
    static func fetchCategories() -> [CategoryCellViewModel] {
        return [
            .init(title: "All", isSelected: true),
            .init(title: "Action", isSelected: false),
            .init(title: "Adventure", isSelected: false),
            .init(title: "Erotic", isSelected: false),
            .init(title: "Exotic", isSelected: false),
            .init(title: "Comedy", isSelected: false)
        ]
    }
}

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.borderWidth = 0.7
        layer.cornerRadius = 17
        layer.borderColor = UIColor.gray.cgColor
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: CategoryCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.isSelected ? .white : .gray
        backgroundColor = viewModel.isSelected ? .custom.mainBlue : .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(
            x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
}

// MARK: - Private methods

private extension CategoryCollectionViewCell {
    func setupCell() {
        addSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
}
