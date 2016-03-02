import Foundation

public struct AttributedVector {
    
    public var location : Vector3D
    public var color : Color?
    public var normal : Vector3D?
    public var windowCoordinate : Point?
    public var normalizedDeviceCoordinate : Vector3D?
    
    public init(_ location: Vector3D, _ color: Color?, _ normal: Vector3D?, _ windowCoordinate: Point? = nil, _ normalizedDeviceCoordinate: Vector3D? = nil) {
        self.location = location
        self.color    = color
        self.normal   = normal
        self.windowCoordinate = windowCoordinate
        self.normalizedDeviceCoordinate = normalizedDeviceCoordinate
    }
}