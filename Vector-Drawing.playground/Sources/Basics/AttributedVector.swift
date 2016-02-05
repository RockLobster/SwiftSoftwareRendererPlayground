import Foundation

public struct AttributedVector {
    
    public let location : Vector3D
    public let color    : Color?
    public let normal   : Vector3D?
    
    public init(_ location: Vector3D, _ color: Color?, _ normal: Vector3D?) {
        self.location = location
        self.color    = color
        self.normal   = normal
    }
}