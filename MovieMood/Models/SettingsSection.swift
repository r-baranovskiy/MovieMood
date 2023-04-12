import Foundation

struct SettingsSection {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let imageName: String
    var type: OptionType = .simple
    let handler: (() -> Void)
}

enum OptionType: String {
    case darkMode = "isOnDarkMode"
    case next
    case simple
}
