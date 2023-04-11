import Foundation
import RealmSwift

protocol RealmManagerProtocol: AnyObject {
    func saveUser(user: UserRealm, completion: @escaping (Bool) -> Void)
    func fetchUsers(completion: @escaping ([UserRealm]) -> Void)
    func removeObject(object: Object, completion: @escaping (Bool) -> Void)
    func removeAll(completion: @escaping (Bool) -> Void)
}

final class RealmManager: RealmManagerProtocol {
    static let shared = RealmManager()
    
    private let realm: Realm? = {
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            return realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
     
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
    
    func fetchUsers(completion: @escaping ([UserRealm]) -> Void) {
        guard let users = realm?.objects(UserRealm.self) else { return }
        completion(Array(users))
    }
    
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
    
    func removeAll(completion: @escaping (Bool) -> Void) {
        do {
            try realm?.write({
                realm?.deleteAll()
                completion(true)
            })
        } catch {
            completion(false)
        }
    }
    
}
