import UIKit

protocol FilterPopupViewDelegate: AnyObject {
    func didTapApplyFilter(with genre: String, votes: String)
    func didTapClose()
}

final class FilterPopupView: UIView {
    
    weak var delegate: FilterPopupViewDelegate?
    
    // MARK: - Properties
    
    private let oneStarButton = StarButton(stars: .one)
    private let twoStarButton = StarButton(stars: .two)
    private let threeStarButton = StarButton(stars: .three)
    private let fourStarButton = StarButton(stars: .four)
    private let fiveStarButton = StarButton(stars: .five)
    
    private let horrorButton = CategoryButton(category: .horror)
    private let actionButton = CategoryButton(category: .action)
    private let adventureButton = CategoryButton(category: .adventure)
    private let mysteryButton = CategoryButton(category: .mystery)
    private let fantasyButton = CategoryButton(category: .fantasy)
    private let comedyButton = CategoryButton(category: .comedy)
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cross")?
            .withTintColor(.label), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 12).isActive = true
        button.widthAnchor.constraint(equalToConstant: 12).isActive = true
        return button
    }()
    
    private let clearFiltersButton: UIButton = {
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear filters", for: .normal)
        clearButton.contentHorizontalAlignment = .right
        clearButton.setTitleColor(.custom.mainBlue, for: .normal)
        clearButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return clearButton
    }()
    
    private let applyFiltersButton = BlueButton(withStyle: .applyFilters)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .custom.mainBackground
        setupView()
        setTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapClear() {
        [
            horrorButton, actionButton, adventureButton, mysteryButton,
            fantasyButton, comedyButton, oneStarButton, twoStarButton,
            threeStarButton, fourStarButton, fiveStarButton
        ].forEach({
            $0.isSelected = false
            $0.backgroundColor = .clear
        })
    }
    
    @objc
    private func didTapClose() {
        delegate?.didTapClose()
    }
    
    @objc
    private func selectGenreButton(_ sender: UIButton) {
        
        let buttons = [
            horrorButton, actionButton, adventureButton, mysteryButton,
            fantasyButton, comedyButton
        ]
        for button in buttons {
            button.isSelected = false
            button.backgroundColor = .clear
        }
        

        sender.isSelected = true
        sender.backgroundColor = .custom.mainBlue
    }
    
    @objc
    private func selectStarButton(_ sender: UIButton) {
        let buttons = [
            oneStarButton, twoStarButton, threeStarButton,
            fourStarButton, fiveStarButton
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
        let filteredGenres = [
            horrorButton, actionButton, adventureButton,
            mysteryButton, fantasyButton, comedyButton
        ]
        
        let filteredVotes = [
            oneStarButton,twoStarButton, threeStarButton,
            fourStarButton, fiveStarButton
        ]
        
        var selectedGenre = ""
        var selectedVote = ""
        
        for genre in filteredGenres {
            if genre.isSelected {
                selectedGenre = genre.currentTitle ?? ""
            }
        }
        
        for vote in filteredVotes {
            if vote.isSelected {
                selectedVote = vote.currentTitle ?? ""
            }
        }
        
        delegate?.didTapApplyFilter(with: selectedGenre, votes: selectedVote)
    }
    
    private func setTargets() {
        closeButton.addTarget(self, action: #selector(didTapClose),
                              for: .touchUpInside)
        
        clearFiltersButton.addTarget(self, action: #selector(didTapClear),
                                     for: .touchUpInside)
        
        applyFiltersButton.addTarget(self, action: #selector(didTapApplyFilter),
                                     for: .touchUpInside)
        [
            horrorButton, actionButton, adventureButton,
            mysteryButton, fantasyButton, comedyButton
        ].forEach({ $0.addTarget(self, action: #selector(selectGenreButton),
                                 for: .touchUpInside) })
        [
            oneStarButton,twoStarButton, threeStarButton,
            fourStarButton, fiveStarButton
        ].forEach({ $0.addTarget(self, action: #selector(selectStarButton),
                                 for: .touchUpInside) })
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
            font: .systemFont(ofSize: 18, weight: .semibold),
            textAlignment: .left, color: .label)
        
        let starRatingLabel = UILabel(
            text: "Star Rating",
            font: .systemFont(ofSize: 18, weight: .semibold),
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
            subviews: [closeButton, titleLabel, clearFiltersButton],
            axis: .horizontal, spacing: 10, aligment: .fill,
            distribution: .fill
        )
        
        let filtersStackView = UIStackView(
            subviews: [upperStackView, categoriesLabel,
                       categoriesContainer, starRatingLabel,
                       starRatingContainer, applyFiltersButton],
            axis: .vertical, spacing: 10, aligment: .fill,
            distribution: .fill
        )
        
        let firstRowCategoriesButtons = UIStackView(
            subviews: [horrorButton, actionButton, adventureButton],
            axis: .horizontal, spacing: 12, aligment: .bottom,
            distribution: .equalSpacing
        )
        
        let secondRowCategoriesButtons = UIStackView(
            subviews: [mysteryButton, fantasyButton, comedyButton],
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
            
            horrorButton.widthAnchor.constraint(equalTo: horrorButton.heightAnchor, multiplier: 1.5/1),
            actionButton.widthAnchor.constraint(equalTo: actionButton.heightAnchor, multiplier: 2/1),
            adventureButton.widthAnchor.constraint(equalTo: adventureButton.heightAnchor, multiplier: 2.8/1),
            mysteryButton.widthAnchor.constraint(equalTo: mysteryButton.heightAnchor, multiplier: 2.5/1),
            fantasyButton.widthAnchor.constraint(equalTo: fantasyButton.heightAnchor, multiplier: 2.5/1),
            comedyButton.widthAnchor.constraint(equalTo: comedyButton.heightAnchor, multiplier: 2.2/1),
            
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
