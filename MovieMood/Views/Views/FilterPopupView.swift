import UIKit

protocol FilterPopupViewDelegate: AnyObject {
    func didTapApplyFilter(with filter: [String])
}

final class FilterPopupView: UIView {
    
    weak var delegate: FilterPopupViewDelegate?
    
    // MARK: - Properties
    
    private let oneStarButton = StarButton(stars: .one)
    private let twoStarButton = StarButton(stars: .two)
    private let threeStarButton = StarButton(stars: .three)
    private let fourStarButton = StarButton(stars: .four)
    private let fiveStarButton = StarButton(stars: .five)
    
    private let allButton = CategoryButton(category: .all)
    private let actionButton = CategoryButton(category: .action)
    private let adventureButton = CategoryButton(category: .adventure)
    private let mysteryButton = CategoryButton(category: .mystery)
    private let fantasyButton = CategoryButton(category: .fantasy)
    private let othersButton = CategoryButton(category: .others)
    
    private let clearFiltersButton: UIButton = {
        let clearButton = UIButton()
        clearButton.setTitle("Clear filters", for: .normal)
        clearButton.setTitleColor(.custom.mainBlue, for: .normal)
        clearButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return clearButton
    }()
    
    private let applyFiltersButton = BlueButton(withStyle: .applyFilters)
    
    private var isSelectedStarButton: Bool = false {
        didSet {
            
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white //.custom.lightGray
        setupView()
        setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc
    private func selectButton(_ sender: UIButton) {
        let buttons = [
            allButton, actionButton, adventureButton, mysteryButton,
            fantasyButton, othersButton
        ]
        for button in buttons {
            button.isSelected = false
            button.backgroundColor = .clear
        }
        
        sender.isSelected = true
        sender.backgroundColor = .custom.mainBlue
    }
    
    @objc
    private func didTapApplyFilter(_ sender: UIButton) {
        let filtersButton = [
            oneStarButton,twoStarButton, threeStarButton,
            fourStarButton, fiveStarButton, allButton, actionButton,
            adventureButton, mysteryButton, fantasyButton, othersButton
        ]
        
        var isSelectedTitleStrings = [String]()
        
        for button in filtersButton {
            if button.isSelected {
                if let title = button.currentTitle {
                    isSelectedTitleStrings.append(title)
                }
            }
        }
        
        delegate?.didTapApplyFilter(with: isSelectedTitleStrings)
    }
    
    private func setTargets() {
        applyFiltersButton.addTarget(self, action: #selector(didTapApplyFilter),
                                     for: .touchUpInside)
        [
            oneStarButton,twoStarButton, threeStarButton,
            fourStarButton, fiveStarButton, allButton, actionButton,
            adventureButton, mysteryButton, fantasyButton, othersButton
        ].forEach({ $0.addTarget(self, action: #selector(selectButton), for: .touchUpInside) })
    }
    
    
    // MARK: - Setup View
    
    private func setupView() {
        layer.cornerRadius = 25
        
        let titleLabel = UILabel(
            text: "Filter",
            font: .systemFont(ofSize: 18, weight: .bold),
            textAlignment: .left, color: .label)
        
        let categoriesLabel = UILabel(
            text: "Categories",
            font: .systemFont(ofSize: 16, weight: .bold),
            textAlignment: .left, color: .label)
        
        let starRatingLabel = UILabel(
            text: "Star Rating",
            font: .systemFont(ofSize: 16, weight: .bold),
            textAlignment: .left, color: .label)
        
        let categoriesContainer: UIView = {
            let catView = UIView()
            return catView
        }()
        
        let starRatingContainer: UIView = {
            let ratingView = UIView()
            return ratingView
        }()
                
        let upperStackView = UIStackView(
            subviews: [titleLabel, clearFiltersButton],
            axis: .horizontal, spacing: 200, aligment: .fill,
            distribution: .fill
        )
        
        let filtersStackView = UIStackView(
            subviews: [upperStackView, categoriesLabel, categoriesContainer, starRatingLabel, starRatingContainer, applyFiltersButton],
            axis: .vertical, spacing: 10, aligment: .fill,
            distribution: .fill
        )
        
        let firstRowCategoriesButtons = UIStackView(
            subviews: [allButton, actionButton, adventureButton],
            axis: .horizontal, spacing: 12, aligment: .bottom,
            distribution: .equalSpacing
        )
        
        let secondRowCategoriesButtons = UIStackView(
            subviews: [mysteryButton, fantasyButton, othersButton],
            axis: .horizontal, spacing: 12, aligment: .top,
            distribution: .equalSpacing
        )
        
        let categoriesButtons = UIStackView(
            subviews: [firstRowCategoriesButtons, secondRowCategoriesButtons],
            axis: .vertical, spacing: 12, aligment: .leading,
            distribution: .fillProportionally
        )
        
        let firstRowStarsButtons = UIStackView(
            subviews: [oneStarButton, twoStarButton, threeStarButton],
            axis: .horizontal, spacing: 12, aligment: .bottom,
            distribution: .fillProportionally
        )
        
        let secondRowStarsButtons = UIStackView(
            subviews: [fourStarButton, fiveStarButton],
            axis: .horizontal, spacing: 12, aligment: .top,
            distribution: .fillProportionally
        )
        
        let starsButtons = UIStackView(
            subviews: [firstRowStarsButtons, secondRowStarsButtons],
            axis: .vertical, spacing: 12, aligment: .leading,
            distribution: .fillProportionally
        )
        
        categoriesContainer.addSubviewWithoutTranslates(categoriesButtons)
        starRatingContainer.addSubviewWithoutTranslates(starsButtons)
        
        addSubviewWithoutTranslates(filtersStackView)
        
        NSLayoutConstraint.activate([
            filtersStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            filtersStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            filtersStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            filtersStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            upperStackView.widthAnchor.constraint(equalTo: filtersStackView.widthAnchor),
            
            categoriesContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            categoriesContainer.widthAnchor.constraint(equalTo: filtersStackView.widthAnchor),
            
            starRatingContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8/4),
            starRatingContainer.widthAnchor.constraint(equalTo: filtersStackView.widthAnchor),
            
            categoriesButtons.topAnchor.constraint(equalTo: categoriesContainer.topAnchor),
            categoriesButtons.leadingAnchor.constraint(equalTo: categoriesContainer.leadingAnchor),
            categoriesButtons.trailingAnchor.constraint(equalTo: categoriesContainer.trailingAnchor),
            categoriesButtons.bottomAnchor.constraint(equalTo: categoriesContainer.bottomAnchor),
            
            allButton.widthAnchor.constraint(equalTo: allButton.heightAnchor, multiplier: 1.5/1),
            actionButton.widthAnchor.constraint(equalTo: actionButton.heightAnchor, multiplier: 2/1),
            adventureButton.widthAnchor.constraint(equalTo: adventureButton.heightAnchor, multiplier: 2.8/1),
            mysteryButton.widthAnchor.constraint(equalTo: mysteryButton.heightAnchor, multiplier: 2.5/1),
            fantasyButton.widthAnchor.constraint(equalTo: fantasyButton.heightAnchor, multiplier: 2.5/1),
            othersButton.widthAnchor.constraint(equalTo: othersButton.heightAnchor, multiplier: 2.2/1),
            
            starsButtons.topAnchor.constraint(equalTo: starRatingContainer.topAnchor),
            starsButtons.leadingAnchor.constraint(equalTo: starRatingContainer.leadingAnchor),
            starsButtons.trailingAnchor.constraint(equalTo: starRatingContainer.trailingAnchor),
            starsButtons.bottomAnchor.constraint(equalTo: starRatingContainer.bottomAnchor),
            
            oneStarButton.widthAnchor.constraint(equalTo: oneStarButton.heightAnchor, multiplier: 1.5/1),
            twoStarButton.widthAnchor.constraint(equalTo: twoStarButton.heightAnchor, multiplier: 2.2/1),
            threeStarButton.widthAnchor.constraint(equalTo: threeStarButton.heightAnchor, multiplier: 3/1),
            fourStarButton.widthAnchor.constraint(equalTo: fourStarButton.heightAnchor, multiplier: 3.8/1),
            fiveStarButton.widthAnchor.constraint(equalTo: fiveStarButton.heightAnchor, multiplier: 4.5/1)
            
        ])
    }
}
