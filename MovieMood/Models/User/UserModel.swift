import Foundation
import RealmSwift

@objcMembers
final class UserModel: Object {
    dynamic var name: String = ""
    dynamic var userId: String = ""
    
    convenience init(userName: String, userId: String) {
        self.init()
        self.userId = userId
        self.name = userName
    }
}
