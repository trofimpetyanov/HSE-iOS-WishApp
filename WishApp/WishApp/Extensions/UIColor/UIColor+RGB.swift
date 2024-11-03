import UIKit

extension UIColor {
    typealias RGB = (red: Double, green: Double, blue: Double)
    
    func components() -> RGB {
        let components = self.cgColor.components ?? [0, 0, 0, 0]
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        
        return (red, green, blue)
    }
    
    static func randomRGB() -> RGB {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        
        return (red, green, blue)
    }
}
