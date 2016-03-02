import Foundation

public typealias VertexShader = (AttributedVector) -> AttributedVector

public func SimpleProjectionShader(projectionMatrix: Matrix4x4) -> VertexShader {
    return { (vertex) -> AttributedVector in
        return AttributedVector(
            projectionMatrix * vertex.location,
            vertex.color,
            vertex.normal,
            vertex.windowCoordinate,
            vertex.normalizedDeviceCoordinate
        )
    }
}