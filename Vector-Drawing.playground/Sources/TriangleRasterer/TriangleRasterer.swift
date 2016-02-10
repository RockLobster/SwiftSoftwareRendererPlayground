import Foundation

public protocol TriangleRasterer {
    
    func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, locationsAreInNormalizedDeviceCoordinates: Bool)
}