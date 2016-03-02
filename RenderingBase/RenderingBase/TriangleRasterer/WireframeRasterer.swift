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
    
    private func pixelPointForLocation(location: Vector3D, locationsAreInNormalizedDeviceCoordinates: Bool) -> Point {
        return locationsAreInNormalizedDeviceCoordinates ? target.pixelCoordinatesForNormalizedDeviceCoordinate(location) : Point(location.x, location.y)
    }
    
    public func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, locationsAreInNormalizedDeviceCoordinates: Bool) {
        let v1 = pixelPointForLocation(vertice1.location, locationsAreInNormalizedDeviceCoordinates: locationsAreInNormalizedDeviceCoordinates)
        let v2 = pixelPointForLocation(vertice2.location, locationsAreInNormalizedDeviceCoordinates: locationsAreInNormalizedDeviceCoordinates)
        let v3 = pixelPointForLocation(vertice3.location, locationsAreInNormalizedDeviceCoordinates: locationsAreInNormalizedDeviceCoordinates)
        
        lineDrawer.drawLine(v1, end: v2, color: self.lineColor)
        lineDrawer.drawLine(v2, end: v3, color: self.lineColor)
        lineDrawer.drawLine(v3, end: v1, color: self.lineColor)
    }
}