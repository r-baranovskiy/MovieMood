import Foundation

struct SettingsSection {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let imageName: String
    let handler: (() -> Void)
}

enum SectionAttributes: String {
    case profile = "Profile"
    case changePassword = "Change Password"
    case forgotPassword = "Forgot Password"
    case darkMode = "Dark Mode"
    
    var imageName: String {
        switch self {
        case .profile:
            return "person-icon"
        case .changePassword:
            return "lock-icon"
        case .forgotPassword:
            return "unlock-icon"
        case .darkMode:
            return "activity-icon"
        }
    }
}
