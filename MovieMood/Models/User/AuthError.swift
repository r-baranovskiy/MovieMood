import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case unknownError
    case serverError
    case notLoggedIn
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid email format", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Passwords don't match", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknow error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error. Try again later.", comment: "")
        case .notLoggedIn:
            return NSLocalizedString("User isn't logged In", comment: "")
        }
    }
}
