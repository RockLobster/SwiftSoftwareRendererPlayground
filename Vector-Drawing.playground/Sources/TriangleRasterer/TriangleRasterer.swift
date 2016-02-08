import Foundation

public typealias FragmentShader = (AttributedVector) -> Color?

public protocol TriangleRasterer {
    
    func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector)
}