/*
 let heightTabBar = tabBarController?.tabBar.frame.height ?? 0
print(heightTabBar)
view.addSubview(filterPopupView)
filterPopupView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height / 2)
UIView.animate(withDuration: 0.3) {
    self.filterPopupView.frame.origin.y -= (self.view.frame.height / 2) + heightTabBar
    
}
 */


import UIKit

final class FilterPopupView: UIView {
    
    private let oneStarButton = StarButton(stars: .one)
    private let twoStarButton = StarButton(stars: .two)
    private let threeStarButton = StarButton(stars: .three)
    private let fourStarButton = StarButton(stars: .four)
    private let fiveStarButton = StarButton(stars: .five)
    
    private let allButton = CategoryButton(category: .all)
    private let actionButton = CategoryButton(category: .action)
    private let adventureButton = CategoryButton(category: .adventure)
    private let eroticButton = CategoryButton(category: .erotic)
    private let exoticButton = CategoryButton(category: .exotic)
    private let comedyButton = CategoryButton(category: .comedy)
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .lightGray
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
            catView.backgroundColor = .systemOrange
            return catView
        }()
        
        let starRatingContainer: UIView = {
            let ratingView = UIView()
            ratingView.backgroundColor = .systemGreen
            
            return ratingView
        }()
        
        let applyFiltersButton = BlueButton(withStyle: .applyFilters)
        
        let filtersStackView = UIStackView(
            subviews: [titleLabel, categoriesLabel, categoriesContainer, starRatingLabel, starRatingContainer, applyFiltersButton],
            axis: .vertical, spacing: 2, aligment: .fill,
            distribution: .fill
        )
        
        let firstRowCategoriesButtons = UIStackView(
            subviews: [allButton, actionButton, adventureButton],
            axis: .horizontal, spacing: 5, aligment: .leading,
            distribution: .fillProportionally
        )
        
        let secondRowCategoriesButtons = UIStackView(
            subviews: [eroticButton, exoticButton, comedyButton],
            axis: .horizontal, spacing: 5, aligment: .leading,
            distribution: .fillProportionally
        )
        
        let categoriesButtons = UIStackView(
            subviews: [firstRowCategoriesButtons, secondRowCategoriesButtons],
            axis: .vertical, spacing: 2, aligment: .leading,
            distribution: .fill
        )
        
        let firstRowStarsButtons = UIStackView(
            subviews: [oneStarButton, twoStarButton, threeStarButton],
            axis: .horizontal, spacing: 5, aligment: .leading,
            distribution: .fillProportionally
        )
        
        let secondRowStarsButtons = UIStackView(
            subviews: [fourStarButton, fiveStarButton],
            axis: .horizontal, spacing: 5, aligment: .leading,
            distribution: .fillProportionally
        )
        
        let starsButtons = UIStackView(
            subviews: [firstRowStarsButtons, secondRowStarsButtons],
            axis: .vertical, spacing: 2, aligment: .leading,
            distribution: .fill
        )
        
        categoriesContainer.addSubviewWithoutTranslates(categoriesButtons)
        starRatingContainer.addSubviewWithoutTranslates(starsButtons)
        
//        addSubviewWithoutTranslates(titleLabel, categoriesLabel, starRatingLabel, categoriesContainer, starRatingContainer, applyFiltersButton)
        addSubviewWithoutTranslates(filtersStackView)
        
        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//
//            categoriesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
//            categoriesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            categoriesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//
//            categoriesContainer.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 5),
//            categoriesContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            categoriesContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
//
//            starRatingLabel.topAnchor.constraint(equalTo: categoriesContainer.bottomAnchor, constant: 5),
//            starRatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            starRatingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//
//            starRatingContainer.topAnchor.constraint(equalTo: starRatingLabel.bottomAnchor, constant: 5),
//            starRatingContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            starRatingContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
//
//            applyFiltersButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
//            applyFiltersButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            applyFiltersButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            filtersStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            filtersStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            filtersStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            filtersStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            categoriesContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            categoriesContainer.widthAnchor.constraint(equalTo: filtersStackView.widthAnchor),
            
            starRatingContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            starRatingContainer.widthAnchor.constraint(equalTo: filtersStackView.widthAnchor),
            
            categoriesButtons.topAnchor.constraint(equalTo: categoriesContainer.topAnchor),
            categoriesButtons.leadingAnchor.constraint(equalTo: categoriesContainer.leadingAnchor),
            categoriesButtons.trailingAnchor.constraint(equalTo: categoriesContainer.trailingAnchor),
            categoriesButtons.bottomAnchor.constraint(equalTo: categoriesContainer.bottomAnchor),
            
            starsButtons.topAnchor.constraint(equalTo: starRatingContainer.topAnchor),
            starsButtons.leadingAnchor.constraint(equalTo: starRatingContainer.leadingAnchor),
            starsButtons.trailingAnchor.constraint(equalTo: starRatingContainer.trailingAnchor),
            starsButtons.bottomAnchor.constraint(equalTo: starRatingContainer.bottomAnchor),
            
            
//            firstRowStarsButtons.widthAnchor.constraint(equalTo: starsButtons.widthAnchor),
//            secondRowStarsButtons.widthAnchor.constraint(equalTo: starsButtons.widthAnchor)
        ])
    }
}
