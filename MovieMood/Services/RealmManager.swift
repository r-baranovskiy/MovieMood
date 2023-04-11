import Foundation
import RealmSwift

protocol RealmManagerProtocol: AnyObject {
    func saveUser(userID: String, user: UserRealm, completion: @escaping (Bool) -> Void)
    func fetchAllUsers(completion: @escaping ([UserRealm]) -> Void)
    func removeObject(object: Object, completion: @escaping (Bool) -> Void)
    func removeAll(completion: @escaping (Bool) -> Void)
    func fetchFilms(userId: String, completion: @escaping ([MovieRealm]) -> Void)
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
    
    
    /// Attempt to save user when user passed registration
    /// - Parameters:
    ///   - user: UserModel
    ///   - completion: Returns true if okey
    func saveUser(userID: String, user: UserRealm, completion: @escaping (Bool) -> Void) {
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
    
    /// Attempt to crear all the data in Realm
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
