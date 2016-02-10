import Foundation

public class PointCloudRasterer : TriangleRasterer {
    
    let target: Bitmap
    let pointColor: Color
    
    public required init(target: Bitmap, pointColor: Color) {
        self.target = target
        self.pointColor = pointColor
    }
    
    private func drawToPixel(x: Int, y:Int) {
        target[x, y, 0] = self.pointColor.red
        target[x, y, 1] = self.pointColor.green
        target[x, y, 2] = self.pointColor.blue
    }
    
    private func pixelPointForLocation(location: Vector3D, locationsAreInScreenSpace: Bool) -> Point {
        return locationsAreInScreenSpace ? target.pixelCoordinatesForEyeSpaceVector(location) : (location.x, location.y)
    }
    
    private func drawPoint(point: Point) {
        drawToPixel(Int(round(point.x)), y: Int(round(point.y)))
    }
    
    public func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, locationsAreInScreenSpace: Bool) {
        
        let v1 = pixelPointForLocation(vertice1.location, locationsAreInScreenSpace: locationsAreInScreenSpace)
        let v2 = pixelPointForLocation(vertice2.location, locationsAreInScreenSpace: locationsAreInScreenSpace)
        let v3 = pixelPointForLocation(vertice3.location, locationsAreInScreenSpace: locationsAreInScreenSpace)
        
        drawPoint(v1)
        drawPoint(v2)
        drawPoint(v3)
    }
}