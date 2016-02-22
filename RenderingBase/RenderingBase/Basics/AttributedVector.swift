import Foundation

public struct AttributedVector {
    
    public let location         : Vector3D
    public let color            : Color?
    public let normal           : Vector3D?
    public var windowCoordinate : Point?
    
    public init(_ location: Vector3D, _ color: Color?, _ normal: Vector3D?, _ windowCoordinate: Point? = nil) {
        self.location = location
        self.color    = color
        self.normal   = normal
        self.windowCoordinate = windowCoordinate
    }
}