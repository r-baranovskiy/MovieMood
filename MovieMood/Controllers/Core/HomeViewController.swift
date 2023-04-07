import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let filmCovers: [UIImage] = [
        UIImage(named: "mock-film-one")!,
        UIImage(named: "mock-film-two")!,
        UIImage(named: "mock-film-three")!,
        UIImage(named: "mock-film-four")!
    ]
    
    private var userImageView: UIImageView = {
        let userIV = UIImageView()
        userIV.clipsToBounds = true
        userIV.contentMode = .scaleAspectFill
        userIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userIV.layer.cornerRadius = userIV.frame.height / 2
        userIV.image = UIImage(named: "mock-person")
        return userIV
    }()
    
    private var usernameLabel = UILabel(
        text: "HI, Nikolai", font: .systemFont(ofSize: 18, weight: .bold),
        textAlignment: .left, color: .label
    )
    
    private let additionalInfoLabel = UILabel(
        text: "only streaming movie lovers",
        font: .systemFont(ofSize: 12, weight: .medium),
        textAlignment: .left, color: .custom.lightGray
    )
    
    private lazy var carouselView: UIView = {
        return TransformView(
            images: filmCovers, imageSize: CGSize(width: 100, height: 150),
            viewSize: CGSize(width: view.frame.width, height: 150)
        )
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension HomeViewController {
    private func setupView() {
        let labelsStackView = UIStackView(
            subviews: [usernameLabel, additionalInfoLabel],
            axis: .vertical, spacing: 2, aligment: .leading,
            distribution: .fill
        )
        
        let topStackView = UIStackView(
            subviews: [userImageView, labelsStackView], axis: .horizontal,
            spacing: 15, aligment: .leading, distribution: .fill
        )
        
        view.backgroundColor = .custom.mainBackground
        view.addSubviewWithoutTranslates(topStackView, carouselView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16
            ),
            topStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 24
            ),
            topStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: 24
            ),
            topStackView.heightAnchor.constraint(equalToConstant: 40),
            
            carouselView.topAnchor.constraint(
                equalTo: topStackView.bottomAnchor, constant: 100
            ),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
