import Foundation
import FirebaseAuth

/// Manager responsible for signing in, up, and out
final class AuthManager {
    /// Singleton instance of the manager
    static let shared = AuthManager()
    
    /// Attempt to sign up
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - confirmPassword: User confirm password
    ///   - firstName: User Firstname
    ///   - lastName: User Lastname
    ///   - completion: Callback that returns MovieUser or result
    func createUser(email: String?, password: String?, confirmPassword: String?,
                    firstName: String?, lastName: String?,
                    completion: @escaping (Result<MovieUser, Error>) -> Void) {
        guard let email = email, let password = password,
              let confirmPassword = confirmPassword,
              let firstName = firstName, let lastName = lastName,
              email != "", password != "", confirmPassword != "",
              firstName != "", lastName != "" else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard password == confirmPassword else {
            completion(.failure(AuthError.passwordNotMatched))
            return
        }
        
        Auth.auth().createUser(withEmail: email,
                               password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result {
                if let email = result.user.email {
                    let user = MovieUser(
                        id: result.user.uid,
                        firstName: firstName, lastName: lastName, email: email
                    )
                    completion(.success(user))
                } else {
                    completion(.failure(AuthError.unknownError))
                }
            }
        }
    }
}
