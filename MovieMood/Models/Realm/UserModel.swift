import Foundation
import RealmSwift

@objcMembers
final class UserRealm: Object {
    
    dynamic var name: String = ""
    dynamic var userId: String = ""
    var movies = List<MovieRealm>()
    
    convenience init(userName: String, userId: String) {
        self.init()
        self.userId = userId
        self.name = userName
    }
}
