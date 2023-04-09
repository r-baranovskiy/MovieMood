import UIKit

final class MainTabBarController: UITabBarController {
    
    private let currentUser: MovieUser
    
    // MARK: - Init
    
    init(user: MovieUser) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
        setupHomeButton()
    }
}

// MARK: - generateTabBar()
extension MainTabBarController {
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: SearchViewController(),
                image: UIImage(named: "search-icon"), title: "Search"),
            generateVC(
                viewController: HistoryViewController(),
                image: UIImage(named: "video-icon"), title: "Recent Watch"),
            generateVC(
                viewController: HomeViewController(),
                image: UIImage(), title: "Home"),
            generateVC(
                viewController: FavoriteViewController(),
                image: UIImage(named: "heart-icon"), title: "Favorites"),
            generateVC(
                viewController: SettingsViewController(user: currentUser),
                image: UIImage(named: "profile-icon"))
        ]
    }
}

// MARK: - generateVC()
extension MainTabBarController {
    private func generateVC(viewController: UIViewController, image: UIImage?,
                            title: String) -> UINavigationController {
        viewController.tabBarItem.image = image
        let navVC = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        return navVC
    }
}

// MARK: - setTabBarAppearance()
extension MainTabBarController {
    private func setTabBarAppearance() {
        view.backgroundColor = .systemBackground
        tabBar.itemPositioning = .centered
        tabBar.barStyle = .default
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = .CustomColor().mainBlue
    }
}

// MARK: - setupHomeButton()
extension MainTabBarController {
    private func setupHomeButton() {
        let homeButton = UIButton(type: .custom)
        let homeIcon = UIImage(named: "home-icon")?.withRenderingMode(.alwaysTemplate)
        homeButton.setImage(homeIcon, for: .normal)
        homeButton.tintColor = .white
        homeButton.backgroundColor = .CustomColor().mainBlue
        homeButton.layer.cornerRadius = 24
        homeButton.frame.size = CGSize(width: 48, height: 48)
        tabBar.addSubview(homeButton)

        if let homeItem = tabBar.items?[2] {
            homeItem.isEnabled = false
        }

        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonDown), for: .touchDown)
        homeButton.addTarget(self, action: #selector(homeButtonUp), for: [.touchUpInside, .touchUpOutside])
        tabBar.setNeedsLayout()
        tabBar.layoutIfNeeded()
        
        let space: CGFloat = 4
        homeButton.center = CGPoint(x: tabBar.center.x, y: (tabBar.bounds.height - homeButton.bounds.height / 2) - space)
    }

}

// MARK: - objc functions
extension MainTabBarController {
    @objc private func homeButtonTapped() {
        selectedIndex = 2
    }

    @objc private func homeButtonDown(sender: UIButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        sender.layer.shadowOffset = CGSize(width: 0, height: 2)
        sender.layer.shadowRadius = 4
        sender.layer.shadowOpacity = 0.3
    }

    @objc private func homeButtonUp(sender: UIButton) {
        sender.layer.shadowOpacity = 0
    }
}
