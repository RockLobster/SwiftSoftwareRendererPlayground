import Foundation

public struct Point{
    public let x: FloatType
    public let y: FloatType
    
    public init(_ x: FloatType, _ y: FloatType) {
        self.x = x
        self.y = y
    }
    
    public var debugDescription: String {
        return "Point x: [\(x)] y: [\(y)]"
    }
}