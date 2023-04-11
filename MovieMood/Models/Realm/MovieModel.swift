import Foundation
import RealmSwift

@objcMembers
final class MovieRealm: Object {
    dynamic var movieId = String()
    
//    override class func primaryKey() -> String? {
//        return #keyPath(movieId)
//    }
}
