import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let window = UIWindow(frame: UIScreen.main.bounds)
        AuthManager.shared.fetchCurrentMovieUser { result in
                switch result {
                case .success(let movieUser):
                    window.rootViewController = MainTabBarController(user: movieUser)
                case .failure:
                    window.rootViewController = OnboardingViewController()
                }
            }
        let darkMode = UserDefaults.standard.bool(forKey: OptionType.darkMode.rawValue)
        window.overrideUserInterfaceStyle = darkMode ? .dark : .light
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

