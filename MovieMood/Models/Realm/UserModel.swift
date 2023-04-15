import Foundation
import RealmSwift

@objcMembers
final class UserRealm: Object {
    
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var userId: String = ""
    dynamic var email: String = ""
    dynamic var isMale: Bool = true
    dynamic var userImageData: Data?
    var favoriteMovies = List<MovieRealm>()
    var recentWatchMovies = List<MovieRealm>()
    
    convenience init(firstName: String, lastName: String, userId: String,
                     email: String, userImageData: Data?) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
        self.email = email
        self.userImageData = userImageData
        self.isMale = true
    }
}
