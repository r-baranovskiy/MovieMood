import UIKit

extension UIAlertController {
    static func errorAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }
}
