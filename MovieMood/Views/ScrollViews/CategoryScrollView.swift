import UIKit

final class CategoryScrollView: UIScrollView {
    
    private let horrorButton = CategoryButton(category: .horror)
    private let actionButton = CategoryButton(category: .action)
    private let adventureButton = CategoryButton(category: .adventure)
    private let mysteryButton = CategoryButton(category: .mystery)
    private let fantasyButton = CategoryButton(category: .fantasy)
    private let comedyButton = CategoryButton(category: .comedy)
    
    private lazy var stackView: UIStackView = {
        return UIStackView(
            subviews: [
                horrorButton, actionButton, adventureButton,
                mysteryButton, fantasyButton, comedyButton
            ], axis: .horizontal, spacing: 12,
            aligment: .fill, distribution: .fillProportionally
        )
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupScrollView() {
        showsHorizontalScrollIndicator = false
        
        stackView.arrangedSubviews.forEach({
            $0.widthAnchor.constraint(
                equalToConstant: $0.intrinsicContentSize.width + 20
            ).isActive = true
        })
        
        addSubviewWithoutTranslates(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        self.contentSize = stackView.frame.size
    }
}
