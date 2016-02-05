import Foundation

public typealias FragmentShader = (AttributedVector) -> Color?

public protocol TriangleRasterer {
    
    init(target: Bitmap)
    
    func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, shader: FragmentShader)
}