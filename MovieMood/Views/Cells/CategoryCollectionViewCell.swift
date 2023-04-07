import UIKit

struct CategoryCellViewModel {
    let title: String
    var isSelected: Bool
}

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.layer.cornerRadius = 17
        label.layer.borderWidth = 0.7
        label.layer.borderColor = UIColor.gray.cgColor
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: CategoryCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.isSelected ? .white : .gray
        titleLabel.backgroundColor = viewModel.isSelected ? .gray : .clear
    }
}

// MARK: - Private methods

private extension CategoryCollectionViewCell {
    func setupCell() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
