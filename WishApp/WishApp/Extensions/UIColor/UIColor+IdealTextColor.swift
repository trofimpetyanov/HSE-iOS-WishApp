import UIKit

extension UIColor {
    var idealTextColor: UIColor {
        return luminance < 0.5 ? .white : .black
    }
    
    var luminance: CGFloat {
        let (red, green, blue, _) = self.components()
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue
    }
    
    func isLowContrast(with backgroundColor: UIColor) -> Bool {
        let backgroundLuminance = backgroundColor.luminance
        let foregroundLuminance = self.luminance
        
        let contrast = (max(backgroundLuminance, foregroundLuminance) + 0.05)
            / (min(backgroundLuminance, foregroundLuminance) + 0.05)
        
        return contrast < 3.0
    }

    func adjustedForContrast(with backgroundColor: UIColor) -> UIColor {
        if self.isLowContrast(with: backgroundColor) {
            if backgroundColor.luminance > 0.5 {
                return self.darker(by: 0.3)
            } else {
                return self.lighter(by: 0.3)
            }
        }
        
        return self
    }
    
    func darker(by percentage: CGFloat) -> UIColor {
        self.adjust(by: -1 * abs(percentage))
    }
    
    func lighter(by percentage: CGFloat) -> UIColor {
        self.adjust(by: abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat) -> UIColor {
        let (red, green, blue, alpha) = self.components()
        
        return UIColor(
            red: min(red + percentage, 1.0),
            green: min(green + percentage, 1.0),
            blue: min(blue + percentage, 1.0),
            alpha: alpha
        )
    }
}
