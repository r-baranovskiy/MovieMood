import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont?, textAlignment: NSTextAlignment, color: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = textAlignment
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
    }
}
