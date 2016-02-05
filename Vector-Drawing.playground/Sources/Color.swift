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