import Foundation

public class WireframeRasterer : TriangleRasterer {
    
    let lineDrawer: LineDrawer
    let lineColor: Color
    let target: Bitmap
    
    public required init(target: Bitmap, lineColor: Color) {
        self.target = target
        lineDrawer = BresenhamLineDrawer(target: target)
        self.lineColor = lineColor
    }
    
    private func pixelPointForLocation(location: Vector3D, locationsAreInScreenSpace: Bool) -> Point {
        return locationsAreInScreenSpace ? target.pixelCoordinatesForEyeSpaceVector(location) : (location.x, location.y)
    }
    
    public func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, locationsAreInScreenSpace: Bool) {
        let v1 = pixelPointForLocation(vertice1.location, locationsAreInScreenSpace: locationsAreInScreenSpace)
        let v2 = pixelPointForLocation(vertice2.location, locationsAreInScreenSpace: locationsAreInScreenSpace)
        let v3 = pixelPointForLocation(vertice3.location, locationsAreInScreenSpace: locationsAreInScreenSpace)
        
        lineDrawer.drawLine(v1, end: v2, color: self.lineColor)
        lineDrawer.drawLine(v2, end: v3, color: self.lineColor)
        lineDrawer.drawLine(v3, end: v1, color: self.lineColor)
    }
}