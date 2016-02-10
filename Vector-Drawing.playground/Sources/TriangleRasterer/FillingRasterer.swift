import Foundation

public class FillingRasterer : TriangleRasterer {
    
    let target: Bitmap
    let lineDrawer: LineDrawer
    let fragmentShader: FragmentShader
    
    public required init(target: Bitmap, fragmentShader: FragmentShader) {
        self.target = target
        self.lineDrawer = BresenhamLineDrawer(target: target)
        self.fragmentShader = fragmentShader
    }
    
    private func drawToPixel(x: Int, y:Int, drawColor: Color) {
        target[x, y, 0] = drawColor.red
        target[x, y, 1] = drawColor.green
        target[x, y, 2] = drawColor.blue
    }
    
    private func drawToPixel(x: Float, y: Float, drawColor: Color) {
        self.drawToPixel(Int(round(x)), y: Int(round(y)), drawColor: drawColor);
    }
    
    private func drawVec(vector: AttributedVector, shader: FragmentShader) {
        let optionalFragmentColor = shader(vector)
        
        if let fragmentColor = optionalFragmentColor {
            drawToPixel(vector.windowCoordinate!.x, y: vector.windowCoordinate!.y, drawColor: fragmentColor)
        }
    }
    
    private func pixelPointForLocation(location: Vector3D, locationsAreInNormalizedDeviceCoordinates: Bool) -> Point {
        return locationsAreInNormalizedDeviceCoordinates ? target.pixelCoordinatesForEyeSpaceVector(location) : Point(location.x, location.y)
    }
    
    public func rasterTriangle(var vertice1: AttributedVector, var vertice2: AttributedVector, var vertice3: AttributedVector, locationsAreInNormalizedDeviceCoordinates: Bool) {
        vertice1.windowCoordinate = pixelPointForLocation(vertice1.location, locationsAreInNormalizedDeviceCoordinates: locationsAreInNormalizedDeviceCoordinates)
        vertice2.windowCoordinate = pixelPointForLocation(vertice2.location, locationsAreInNormalizedDeviceCoordinates: locationsAreInNormalizedDeviceCoordinates)
        vertice3.windowCoordinate = pixelPointForLocation(vertice3.location, locationsAreInNormalizedDeviceCoordinates: locationsAreInNormalizedDeviceCoordinates)
        
        var verticeSet = [vertice1, vertice2, vertice3]
        
        verticeSet.sortInPlace { return $0.windowCoordinate!.y < $1.windowCoordinate!.y }
        let firstRange  = verticeSet[1].windowCoordinate!.y - verticeSet[0].windowCoordinate!.y;
        let secondRange = verticeSet[2].windowCoordinate!.y - verticeSet[1].windowCoordinate!.y;
        
        drawVec(verticeSet[0], shader: self.fragmentShader)
        drawVec(verticeSet[1], shader: self.fragmentShader)
        drawVec(verticeSet[2], shader: self.fragmentShader)
        
        for offset in 0..<Int(ceil(firstRange)) {
            let alpha1 = Float(offset)/firstRange;
            let alpha2 = Float(offset)/(firstRange+secondRange);
            
            let interpolatedVector1 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[1], alpha: alpha1)
            let interpolatedVector2 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[2], alpha: alpha2)
            
            rasterHorizontalLine(interpolatedVector1, interpolatedVector2)
        }
        for offset in 0..<Int(ceil(secondRange)) {
            let alpha1 = Float(offset)/secondRange;
            let alpha2 = (Float(offset)+firstRange)/(firstRange+secondRange);
            
            let interpolatedVector1 = AttributedVector.linearInterpolate(verticeSet[1], second: verticeSet[2], alpha: alpha1)
            let interpolatedVector2 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[2], alpha: alpha2)
            
            rasterHorizontalLine(interpolatedVector1, interpolatedVector2)
        }
    }
    
    func calculateAlphaForLocation(location: FloatType, rangeBegin: FloatType, rangeEnd: FloatType) -> FloatType {
        return (location - rangeBegin) / (rangeEnd - rangeBegin)
    }
    
    func rasterHorizontalLine(start: AttributedVector, _ end: AttributedVector) {
        
        if (end.windowCoordinate!.x < start.windowCoordinate!.x) {
            return rasterHorizontalLine(end, start)
        }
        
        let startX = Int(round(start.windowCoordinate!.x))
        let endX   = Int(round(end.windowCoordinate!.x))
        
        let startAlpha = calculateAlphaForLocation(FloatType(startX), rangeBegin: start.windowCoordinate!.x, rangeEnd: end.windowCoordinate!.x)
        let endAlpha = calculateAlphaForLocation(FloatType(endX), rangeBegin: start.windowCoordinate!.x, rangeEnd: end.windowCoordinate!.x)
        
        let alphaIncrement = (endAlpha - startAlpha) / FloatType(endX - startX)
        
        var currentAlpha = startAlpha
        
        for _ in startX...endX {
            let alphaToUse = min(1.0, max(0.0, currentAlpha))
            let vectorAtX = AttributedVector.linearInterpolate(start, second: end, alpha: alphaToUse)
            
            drawVec(vectorAtX, shader: self.fragmentShader)
            
            currentAlpha += alphaIncrement
        }
    }
}