import Foundation
import RealmSwift

protocol RealmManagerProtocol: AnyObject {
    func saveUser(user: UserModel, completion: @escaping (Bool) -> Void)
    func fetchUsers(completion: @escaping ([UserModel]) -> Void)
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
    
     
    func saveUser(user: UserModel, completion: @escaping (Bool) -> Void) {
        do {
            try realm?.write {
                realm?.add(user)
                completion(true)
            }
        } catch {
            completion(false)
        }
    }
    
    func fetchUsers(completion: @escaping ([UserModel]) -> Void) {
        guard let users = realm?.objects(UserModel.self) else { return }
        completion(Array(users))
    }
}
