import Foundation

public class WireframeRasterer : TriangleRasterer {
    
    let lineDrawer: LineDrawer
    let lineColor: Color
    
    public required init(target: Bitmap, lineColor: Color) {
        lineDrawer = BresenhamLineDrawer(target: target)
        self.lineColor = lineColor
    }
    
    public func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector) {
        lineDrawer.drawLine(vertice1.location, end: vertice2.location, color: self.lineColor)
        lineDrawer.drawLine(vertice2.location, end: vertice3.location, color: self.lineColor)
        lineDrawer.drawLine(vertice3.location, end: vertice1.location, color: self.lineColor)
    }
}