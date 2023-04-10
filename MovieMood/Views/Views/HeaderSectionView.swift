import UIKit

final class HeaderSectionView: UIView {
    
    private let titleLabel = UILabel(
        font: .systemFont(ofSize: 12, weight: .regular),
        textAlignment: .left, color: .label
    )
    
    init(sectionTitle: String) {
        self.titleLabel.text = sectionTitle
        super.init(frame: .zero)
        
        addSubviewWithoutTranslates(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(sectionTitle: String) {
        titleLabel.text = sectionTitle
    }
}
