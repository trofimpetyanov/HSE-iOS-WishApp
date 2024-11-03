import UIKit

extension UIColor {
    var idealTextColor: UIColor {
        return isDark ? .white : .black
    }
    
    private var isDark: Bool {
        return luminance() < 0.5
    }
    
    private func luminance() -> CGFloat {
        let (red, green, blue) = self.components()
        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        
        return luminance
    }
}
