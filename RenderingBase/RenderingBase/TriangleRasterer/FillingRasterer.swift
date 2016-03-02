import Foundation

public final class FillingRasterer : TriangleRasterer {
    
    let target: Bitmap
    let fragmentShader: FragmentShader
    let clipper: Clipper
    
    public required init(target: Bitmap, fragmentShader: FragmentShader) {
        self.target = target
        self.clipper = Clipper()
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
    
    public func rasterTriangle(var vertice1: AttributedVector, var vertice2: AttributedVector, var vertice3: AttributedVector, locationsAreInNormalizedDeviceCoordinates: Bool) {
        
        vertice1.normalizedDeviceCoordinate = locationsAreInNormalizedDeviceCoordinates ? vertice1.location : target.normalizedDeviceCoordinate(vertice1.location)
        vertice2.normalizedDeviceCoordinate = locationsAreInNormalizedDeviceCoordinates ? vertice2.location : target.normalizedDeviceCoordinate(vertice2.location)
        vertice3.normalizedDeviceCoordinate = locationsAreInNormalizedDeviceCoordinates ? vertice3.location : target.normalizedDeviceCoordinate(vertice3.location)
        
        vertice1.windowCoordinate = target.pixelCoordinatesForNormalizedDeviceCoordinate(vertice1.normalizedDeviceCoordinate!)
        vertice2.windowCoordinate = target.pixelCoordinatesForNormalizedDeviceCoordinate(vertice2.normalizedDeviceCoordinate!)
        vertice3.windowCoordinate = target.pixelCoordinatesForNormalizedDeviceCoordinate(vertice3.normalizedDeviceCoordinate!)
        
        clipper.clipTriangle([vertice1, vertice2, vertice3]) {
            (triangle: [AttributedVector]) in
            
            self.internal_rasterTriangle(
                triangle[0],
                vertice2: triangle[1],
                vertice3: triangle[2])
        }
    }
    
    private func internal_rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector) {
        
        var verticeSet = [vertice1, vertice2, vertice3]
        
        verticeSet.sortInPlace { return $0.windowCoordinate!.y < $1.windowCoordinate!.y }
        
        let yRangeBegin = Int(round(verticeSet[0].windowCoordinate!.y))
        let yRangeMid   = Int(round(verticeSet[1].windowCoordinate!.y))
        let yRangeEnd   = Int(round(verticeSet[2].windowCoordinate!.y))
        
        for y in yRangeBegin..<yRangeMid {
            
            let alpha1 = BoundingBoxRange(min: verticeSet[0].windowCoordinate!.y, max: verticeSet[1].windowCoordinate!.y)!.alphaForValue(FloatType(y))
            let alpha2 = BoundingBoxRange(min: verticeSet[0].windowCoordinate!.y, max: verticeSet[2].windowCoordinate!.y)!.alphaForValue(FloatType(y))
            
            let interpolatedVector1 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[1], alpha: alpha1)
            let interpolatedVector2 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[2], alpha: alpha2)
            
            rasterHorizontalLine(interpolatedVector1, interpolatedVector2)
        }
        for y in yRangeMid...yRangeEnd {
            
            let alpha1 = BoundingBoxRange(min: verticeSet[1].windowCoordinate!.y, max: verticeSet[2].windowCoordinate!.y)!.alphaForValue(FloatType(y))
            let alpha2 = BoundingBoxRange(min: verticeSet[0].windowCoordinate!.y, max: verticeSet[2].windowCoordinate!.y)!.alphaForValue(FloatType(y))
            
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
        
        let xRangeBegin = max(0, min(target.width-1, Int(round(start.windowCoordinate!.x))))
        let xRangeEnd   = max(0, min(target.width-1, Int(round(end.windowCoordinate!.x))))
        
        for x in xRangeBegin...xRangeEnd {
            let alpha = BoundingBoxRange(min: start.windowCoordinate!.x, max: end.windowCoordinate!.x)!.alphaForValue(FloatType(x))
            let vectorAtX = AttributedVector.linearInterpolate(start, second: end, alpha: alpha)
            drawVec(vectorAtX, shader: self.fragmentShader)
        }
    }
}