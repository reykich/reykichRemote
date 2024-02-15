import Foundation
import UIKit

typealias EmptyClosure = () -> Void

extension CGFloat {
    static var widthScale: Self {
        return UIScreen.main.bounds.width/390
    }
    
    static var heightScale: Self {
        return UIScreen.main.bounds.height/844
    }
    
    var scaled: Self {
        return self * Self.widthScale
    }
    
    var verticalScaled: Self {
        return self * Self.heightScale
    }
}

extension Int {
    private var value: CGFloat { return CGFloat(self) }
    
    var scaled: CGFloat { value.scaled }
    var verticalScaled: CGFloat { value.verticalScaled }
}
