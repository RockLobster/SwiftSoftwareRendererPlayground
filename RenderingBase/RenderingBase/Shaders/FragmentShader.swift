import Foundation

public typealias FragmentShader = (AttributedVector) -> Color?

public let DefaultColorShader: FragmentShader = {$0.color}

public func FixedColorFragmentShader(color: Color) -> FragmentShader {
    return {_ in return color }
}

public func LocationBasedFragmentShader(zDepth: FloatType = 1.0) -> FragmentShader {
    
    return {
        let red   = max(0.0, ($0.location.x + 1.0) / 2 * 255)
        let blue  = max(0.0, ($0.location.y + 1.0) / 2 * 255)
        let green = max(0.0, zDepth - abs(($0.location.z/zDepth)) * 255)
        
        return Color(red: UInt8(red), green: UInt8(green), blue: UInt8(blue) )
    }
}