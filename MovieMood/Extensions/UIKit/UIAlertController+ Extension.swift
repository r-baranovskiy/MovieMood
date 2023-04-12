import UIKit

extension UIAlertController {
    static func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }
    
    static func createAlert(title: String, message: String,
                            completion: @escaping (UIAlertAction) -> (Void)) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: completion))
        return alert
    }
}
