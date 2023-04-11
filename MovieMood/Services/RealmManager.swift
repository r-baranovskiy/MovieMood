import Foundation
import RealmSwift

protocol RealmManagerProtocol: AnyObject {
    func saveUser(user: UserRealm, completion: @escaping (Bool) -> Void)
    func fetchAllUsers(completion: @escaping ([UserRealm]) -> Void)
    func removeObject(object: Object, completion: @escaping (Bool) -> Void)
    func removeAll(completion: @escaping (Bool) -> Void)
    func fetchFilms(userId: String,
                    completion: @escaping ([MovieRealm]) -> Void)
    func isExistRealmUser(userId: String) -> Bool
    func fetchRealmUser(userId: String,
                        completion: @escaping (UserRealm?) -> Void)
    func updateUserData(user: UserRealm, firstName: String, lastName: String,
                        avatarImageData: Data?, isMale: Bool,
                        completion: (Bool) -> Void)
    func isLikedMovie(for user: UserRealm, with movieId: String) -> Bool
    func saveMovie(for user: UserRealm, with filmId: String,
                   completion: @escaping (Bool) -> Void)
    func removeMovie(for user: UserRealm, with filmId: String,
                     completion: @escaping (Bool) -> Void)
}

/// Ream manager instance that uses when need to save user and his favorites movies
final class RealmManager: RealmManagerProtocol {
    
    static let shared = RealmManager()
    
    private let realm: Realm? = {
        let config = Realm.Configuration(schemaVersion: 1)
        { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                
            }
        }
        do {
            let realm = try Realm(configuration: config)
            return realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    /// Check on is favorite movie or not
    /// - Parameters:
    ///   - user: Current realm user
    ///   - movieId: Movie id that need to check
    /// - Returns: Returns true if favorite
    func isLikedMovie(for user: UserRealm, with movieId: String) -> Bool {
        let movies = user.movies
        for movie in movies {
            if movie.movieId == movieId {
                return true
            }
        }
        return false
    }
    
    /// Attempt to save movie ID to realm database
    /// - Parameters:
    ///   - user: Current realm user
    ///   - filmId: Movie id that need to save
    ///   - completion:Returns true if success
    func saveMovie(for user: UserRealm, with filmId: String,
                   completion: @escaping (Bool) -> Void) {
        let movie = MovieRealm()
        movie.movieId = filmId
        do {
            try realm?.write({
                user.movies.append(movie)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Attempt to remove movie ID from realm database
    /// - Parameters:
    ///   - user: Current realm user
    ///   - filmId: Movie id that need to remove
    ///   - completion: Returns true if success
    func removeMovie(for user: UserRealm, with filmId: String,
                     completion: @escaping (Bool) -> Void) {
        let movies = user.movies
        
        for (index, movie) in movies.enumerated() {
            if movie.movieId == filmId {
                do {
                    try realm?.write({
                        movies.remove(at: index)
                        completion(true)
                    })
                } catch {
                    completion(false)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// Attempt to update user data in Realm
    /// - Parameters:
    ///   - user: Current Realm User
    ///   - firstName: User name
    ///   - lastName: User last name
    ///   - avatarImageData: User avatar image data
    ///   - isMale: User sex. Default == male
    ///   - completion: Returns true if okey
    func updateUserData(user: UserRealm, firstName: String, lastName: String,
                        avatarImageData: Data?, isMale: Bool, completion: (Bool) -> Void) {
        do {
            try realm?.write({
                user.firstName = firstName
                user.lastName = lastName
                user.userImageData = avatarImageData
                user.isMale = isMale
                completion(true)
            })
        } catch {
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    
    /// Check on existing user in database
    /// - Parameter userId: User ID
    /// - Returns: Returns true if exists
    func isExistRealmUser(userId: String) -> Bool {
        guard let users = realm?.objects(UserRealm.self) else { return false }
        return users.filter({ $0.userId == userId }).count > 0
    }
    
    /// Attempt to save user when user passed registration
    /// - Parameters:
    ///   - user: UserModel
    ///   - completion: Returns true if okey
    func saveUser(user: UserRealm, completion: @escaping (Bool) -> Void) {
        do {
            try realm?.write {
                realm?.add(user)
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
    
    /// Returns all the favorites movies when user liked
    /// - Parameters:
    ///   - userId: User id that was saved
    ///   - completion: Returns array of movies ID
    func fetchFilms(userId: String, completion: @escaping ([MovieRealm]) -> Void) {
        fetchAllUsers { users in
            for user in users where user.userId == userId {
                completion(Array(user.movies))
            }
        }
    }
    
    /// Attempt to return Realm user from db if exists
    /// - Parameters:
    ///   - userId: User ID
    ///   - completion: Returns optional user if exists
    func fetchRealmUser(userId: String, completion: @escaping (UserRealm?) -> Void) {
        guard let realmUsers = realm?.objects(UserRealm.self) else { return }
        let users = Array(realmUsers)
        let user = users.filter({ $0.userId == userId }).first
        completion(user)
    }
    
    /// Attempt to fetch all the users that were saved
    /// - Parameter completion: Returns array of users
    func fetchAllUsers(completion: @escaping ([UserRealm]) -> Void) {
        guard let users = realm?.objects(UserRealm.self) else { return }
        completion(Array(users))
    }
    
    
    
    /// Attempt to remove any Realm object
    /// - Parameters:
    ///   - object: Any realm class object that need to delete
    ///   - completion: Returns true if okey
    func removeObject(object: RealmSwift.Object, completion: @escaping (Bool) -> Void) {
        do {
            try realm?.write({
                realm?.delete(object)
                completion(true)
            })
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    
    /// Attempt to remove all the data in the realm
    /// - Parameter completion: Returns true if okey
    func removeAll(completion: @escaping (Bool) -> Void) {
        do {
            try realm?.write({
                realm?.deleteAll()
                completion(true)
            })
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
}
