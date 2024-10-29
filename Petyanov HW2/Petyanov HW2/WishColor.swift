import UIKit

struct WishColor {
    var red: Double = 0
    var green: Double = 0
    var blue: Double = 0
    
    var color: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
