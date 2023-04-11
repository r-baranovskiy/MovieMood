import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

/// Manager responsible for signing in, up, and out
final class AuthManager {
    /// Singleton instance of the manager
    static let shared = AuthManager()
    
    /// Check on user logged in or not
    /// - Returns: Returns true if yes or not if false
    func checkOnLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    /// Attempt to logout from account
    /// - Parameter completion: Returns success
    func logOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let error{
            completion(.failure(error))
        }
    }
    
    /// Attempt to change password
    /// - Parameters:
    ///   - password: Current user password
    ///   - newPassword: New user password
    ///   - confirmPassword: Confirm new user password
    ///   - completion: Retturns succes or not
    func changePassword(password: String?, newPassword: String?,
                        confirmPassword: String?,
                        completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let password = password, let newPassword = newPassword,
              let confirmPassword = confirmPassword, password != "",
              newPassword != "", confirmPassword != ""  else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard newPassword == confirmPassword else {
            completion(.failure(AuthError.passwordNotMatched))
            return
        }
        
        let user = Auth.auth().currentUser
        
        if let email = user?.email {
            let credential = EmailAuthProvider.credential(withEmail: email,
                                                          password: password)
            user?.reauthenticate(with: credential) { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    user?.updatePassword(to: newPassword) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(true))
                        }
                    }
                }
            }
        }
    }
    
    /// Attempt to fetch current MovieUser
    /// - Parameter completion: Returns Current MovieUser
    func fetchCurrentMovieUser(completion: @escaping (Result<MovieUser,
                                                      Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(AuthError.notLoggedIn))
            return
        }
        
        let movieUser = MovieUser(id: user.uid,
                                  firstName: user.displayName ?? "",
                                  email: user.email ?? "")
        completion(.success(movieUser))
    }
    
    /// Attempt to login user with email and password
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Returns Firebase User
    func loginWithEmail(email: String?, password: String?,
                        completion: @escaping (Result<MovieUser, Error>) -> Void) {
        guard let email = email, let password = password,
              email != "", password != "" else {
            completion(.failure(AuthError.notFilled))
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let result = result {
                let movieUser = MovieUser(id: result.user.uid,
                                          email: result.user.email!)
                completion(.success(movieUser))
            } else {
                completion(.failure(AuthError.unknownError))
            }
        }
    }
    
    /// Attempt to sign in with google
    /// - Parameters:
    ///   - viewController: View controller that called this method
    ///   - completion: Returns MovieUser
    func loginWithGoogle(viewController: UIViewController,
                         completion: @escaping (Result<MovieUser, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                completion(.failure(AuthError.unknownError))
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let user = result?.user else {
                    completion(.failure(AuthError.unknownError))
                    return
                }
                
                if let userImageUrl = user.photoURL {
                    DispatchQueue.global().async {
                        do {
                            let data = try Data(contentsOf: userImageUrl)
                            
                            let movieUser = MovieUser(
                                id: user.uid, firstName: user.displayName ?? "Guest",
                                email: user.email ?? "",
                                avatarImageData: data
                            )
                            completion(.success(movieUser))
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
    
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
