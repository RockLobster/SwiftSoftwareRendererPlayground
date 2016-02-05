import Foundation

public class WireframeRasterer : TriangleRasterer {
    
    let lineDrawer: LineDrawer
    
    public required init(target: Bitmap) {
        lineDrawer = BresenhamLineDrawer(target: target)
    }
    
    public func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, shader: FragmentShader) {
        lineDrawer.drawLine(vertice1.location, end: vertice2.location, color: Color.Green())
        lineDrawer.drawLine(vertice2.location, end: vertice3.location, color: Color.Green())
        lineDrawer.drawLine(vertice3.location, end: vertice1.location, color: Color.Green())
    }
}