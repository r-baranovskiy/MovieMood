import UIKit

extension UIColor {
    /// Convenience name for uses color F.E. UIColor.custom.mainBackground
    class var custom: CustomColor { return CustomColor() }
    
    /// Returns UIColor from assets
    struct CustomColor {
        var mainBackground: UIColor {
            return UIColor(named: "Main-Background") ?? .systemBackground
        }
        
        var goldColor: UIColor {
            return UIColor(named: "Gold") ?? UIColor(red: 0.612, green: 0.643,
                                                     blue: 0.671, alpha: 1)
        }
        
        var mainBlue: UIColor {
            return UIColor(named: "Main-Blue") ?? .systemBlue
        }
        
        var lightGray: UIColor {
            return UIColor(named: "LightGray") ?? .lightGray
        }
    }
}
