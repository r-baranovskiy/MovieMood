import UIKit

protocol CategoryScrollViewDelegate: AnyObject {
    func didChangeCategory(with tag: Int)
}

final class CategoryScrollView: UIScrollView {
    
    weak var buttonDelegate: CategoryScrollViewDelegate?
    
    private let withTV: Bool
    
    private let allButton = CategoryButton(category: .all)
    private let tvButton = CategoryButton(category: .tv)
    private let horrorButton = CategoryButton(category: .horror)
    private let actionButton = CategoryButton(category: .action)
    private let adventureButton = CategoryButton(category: .adventure)
    private let mysteryButton = CategoryButton(category: .mystery)
    private let fantasyButton = CategoryButton(category: .fantasy)
    private let comedyButton = CategoryButton(category: .comedy)
    
    private lazy var stackView: UIStackView = {
        return UIStackView(
            subviews: [
                allButton, tvButton, horrorButton, actionButton,
                adventureButton, mysteryButton, fantasyButton, comedyButton
            ], axis: .horizontal, spacing: 12,
            aligment: .fill, distribution: .fillProportionally
        )
    }()
    
    init(withTV: Bool) {
        self.withTV = withTV
        super.init(frame: .zero)
        tvButton.isHidden = !withTV
        setupScrollView()
        setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTargets() {
        [horrorButton, actionButton, adventureButton,
         mysteryButton, fantasyButton, comedyButton, allButton, tvButton]
            .forEach({ $0.addTarget(self, action: #selector(selectGenreButton),
                                    for: .touchUpInside) })
        
        horrorButton.tag = 27
        actionButton.tag = 28
        adventureButton.tag = 12
        mysteryButton.tag = 9648
        fantasyButton.tag = 14
        comedyButton.tag = 35
        allButton.tag = 0
        tvButton.tag = 1
    }
    
    // MARK: - Actions
    
    @objc
    private func selectGenreButton(_ sender: UIButton) {
        
        let buttons = [
            allButton, tvButton, horrorButton, actionButton,
            adventureButton, fantasyButton, comedyButton, mysteryButton
        ]
        for button in buttons {
            button.isSelected = false
            button.backgroundColor = .clear
        }
        

        sender.isSelected = true
        buttonDelegate?.didChangeCategory(with: sender.tag)
        sender.backgroundColor = .custom.mainBlue
    }
    
    // MARK: - Setup ScrollView
    
    private func setupScrollView() {
        showsHorizontalScrollIndicator = false
        
        [
            allButton, tvButton, horrorButton, actionButton,
            adventureButton, fantasyButton, comedyButton, mysteryButton
        ].forEach({
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
