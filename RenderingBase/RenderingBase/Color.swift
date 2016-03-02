import Foundation

public struct Color {
    
    public let red:   UInt8
    public let green: UInt8
    public let blue:  UInt8
    
    public init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    
    static public func Red() -> Color {
        return Color(red: 255, green: 0, blue: 0)
    }
    
    static public func Green() -> Color {
        return Color(red: 0, green: 255, blue: 0)
    }
    
    static public func Blue() -> Color {
        return Color(red: 0, green: 0, blue: 255)
    }
    
    static public func Black() -> Color {
        return Color(red: 0, green: 0, blue: 0)
    }
    
    static public func White() -> Color {
        return Color(red: 255, green: 255, blue: 255)
    }
}

public func * (first: Color, second: FloatType) -> Color {
    
    let red   = UInt8( min(255.0, max(0.0, FloatType(first.red) * second)) )
    let green = UInt8( min(255.0, max(0.0, FloatType(first.green) * second)) )
    let blue  = UInt8( min(255.0, max(0.0, FloatType(first.blue) * second)) )
    
    return Color(red: red, green: green, blue: blue)
}

public func + (first: Color, second: Color) -> Color {
    
    let red   = UInt8( min(255, max(0, UInt16(first.red)   + UInt16(second.red))))
    let green = UInt8( min(255, max(0, UInt16(first.green) + UInt16(second.green))))
    let blue  = UInt8( min(255, max(0, UInt16(first.blue)  + UInt16(second.blue))))
    
    return Color(red: red, green: green, blue: blue)
}