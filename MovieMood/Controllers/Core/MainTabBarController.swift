import UIKit

// MARK: - viewDidLoad()
final class MainTabBarController: UITabBarController {

private let apiManager: ApiManagerProtocol = ApiManager(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    
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
                image: UIImage(named: "search-icon")),
            generateVC(
                viewController: HistoryViewController(),
                image: UIImage(named: "video-icon")),
            generateVC(
                viewController: HomeViewController(),
                image: UIImage()),
            generateVC(
                viewController: FavoriteViewController(),
                image: UIImage(named: "heart-icon")),
            generateVC(
                viewController: ProfileViewController(),
                image: UIImage(named: "profile-icon"))
        ]
    }
}

// MARK: - generateVC()
extension MainTabBarController {
    private func generateVC(viewController: UIViewController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.image = image
        return viewController
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

        if let items = self.tabBar.items, items.count > 0 {
            let tabBarItem = items[2]
            tabBarItem.isEnabled = false
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
