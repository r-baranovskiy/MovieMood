import Foundation
import RealmSwift

enum MoviesType {
    case favorite
    case recent
}

protocol RealmManagerProtocol: AnyObject {
    func saveUser(user: UserRealm, completion: @escaping (Bool) -> Void)
    func fetchAllUsers(completion: @escaping ([UserRealm]) -> Void)
    func removeObject(object: Object, completion: @escaping (Bool) -> Void)
    func removeAll(completion: @escaping (Bool) -> Void)
    func isExistRealmUser(userId: String) -> Bool
    func fetchRealmUser(userId: String,
                        completion: @escaping (UserRealm?) -> Void)
    func updateUserData(user: UserRealm, firstName: String, lastName: String,
                        avatarImageData: Data?, isMale: Bool,
                        completion: (Bool) -> Void)
    func fetchMovies(userId: String, moviesType: MoviesType,
                     completion: @escaping ([MovieRealm]) -> Void)
    func isLikedMovie(for user: UserRealm, with movieId: Int) -> Bool
    func isAddedToRecentMovie(for user: UserRealm, with movieId: Int) -> Bool
    func saveMovie(for user: UserRealm, with filmId: Int, moviesType: MoviesType,
                   completion: @escaping (Bool) -> Void)
    func removeMovie(for user: UserRealm, with movieId: Int,
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
    
    /// Attempt to fetch all the movies that user has
    /// - Parameters:
    ///   - userId: Realm User ID
    ///   - moviesType: Movies type that need to fetch
    ///   - completion: Returns array of movies IDs for necessary type
    func fetchMovies(userId: String, moviesType: MoviesType,
                     completion: @escaping ([MovieRealm]) -> Void) {
        switch moviesType {
        case .favorite:
            fetchAllUsers { users in
                for user in users where user.userId == userId {
                    completion(Array(user.favoriteMovies))
                }
            }
        case .recent:
            fetchAllUsers { users in
                for user in users where user.userId == userId {
                    completion(Array(user.recentWatchMovies))
                }
            }
        }
    }
    
    /// Check on is favorite movie or not
    /// - Parameters:
    ///   - user: Current realm user
    ///   - movieId: Movie id that need to check
    /// - Returns: Returns true if favorite
    func isLikedMovie(for user: UserRealm, with movieId: Int) -> Bool {
        let movies = user.favoriteMovies
        for movie in movies {
            if movie.movieId == movieId {
                return true
            }
        }
        return false
    }
    
    /// Check on user favorite movies contain a movie or not
    /// - Parameters:
    ///   - user: Current realm user
    ///   - movieId: Movie id that need to check
    /// - Returns: Returns true if favorite
    func isAddedToRecentMovie(for user: UserRealm, with movieId: Int) -> Bool {
        let movies = user.recentWatchMovies
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
    ///   - moviesType: Movies type that need to save
    ///   - completion: Returns true if success
    func saveMovie(for user: UserRealm, with movieId: Int, moviesType: MoviesType,
                   completion: @escaping (Bool) -> Void) {
        let movie = MovieRealm()
        movie.movieId = movieId
        
        switch moviesType {
        case .favorite:
            do {
                try realm?.write({
                    user.favoriteMovies.append(movie)
                    completion(true)
                })
            } catch {
                completion(false)
                print(error.localizedDescription)
            }
        case .recent:
            do {
                try realm?.write({
                    user.recentWatchMovies.append(movie)
                    completion(true)
                })
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Attempt to remove movie ID from realm database
    /// - Parameters:
    ///   - user: Current realm user
    ///   - filmId: Movie id that need to remove
    ///   - completion: Returns true if success
    func removeMovie(for user: UserRealm, with filmId: Int,
                     completion: @escaping (Bool) -> Void) {
        let movies = user.favoriteMovies
        
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
