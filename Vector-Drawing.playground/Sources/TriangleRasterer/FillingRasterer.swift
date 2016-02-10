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
    
    func drawToPixel(x: Int, y:Int, drawColor: Color) {
        target[x, y, 0] = drawColor.red
        target[x, y, 1] = drawColor.green
        target[x, y, 2] = drawColor.blue
    }
    
    private func drawToPixel(x: Float, y: Float, drawColor: Color) {
        self.drawToPixel(Int(round(x)), y: Int(round(y)), drawColor: drawColor);
    }
    
    func drawVec(vector: AttributedVector, shader: FragmentShader, locationsAreInScreenSpace: Bool) {
        let optionalFragmentColor = shader(vector)
        
        if let fragmentColor = optionalFragmentColor {
            let location = locationsAreInScreenSpace ? target.pixelCoordinatesForEyeSpaceVector(vector.location) : (x: vector.location.x, y: vector.location.y)
            drawToPixel(location.x, y: location.y, drawColor: fragmentColor)
        }
    }
    
    public func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, locationsAreInScreenSpace: Bool) {
        var verticeSet = [vertice1, vertice2, vertice3]
        
        verticeSet.sortInPlace { return $0.location.y < $1.location.y }
        let firstRange  = verticeSet[1].location.y - verticeSet[0].location.y;
        let secondRange = verticeSet[2].location.y - verticeSet[1].location.y;
        
        //drawVec(verticeSet[0], shader: self.fragmentShader, locationsAreInScreenSpace: locationsAreInScreenSpace)
        //drawVec(verticeSet[1], shader: self.fragmentShader, locationsAreInScreenSpace: locationsAreInScreenSpace)
        //drawVec(verticeSet[2], shader: self.fragmentShader, locationsAreInScreenSpace: locationsAreInScreenSpace)
        
        for offset in 0..<Int(ceil(firstRange)) {
            let alpha1 = Float(offset)/firstRange;
            let alpha2 = Float(offset)/(firstRange+secondRange);
            
            let interpolatedVector1 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[1], alpha: alpha1)
            let interpolatedVector2 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[2], alpha: alpha2)
            
            rasterHorizontalLine(interpolatedVector1, interpolatedVector2, locationsAreInScreenSpace: locationsAreInScreenSpace)
        }
        for offset in 0..<Int(ceil(secondRange)) {
            let alpha1 = Float(offset)/secondRange;
            let alpha2 = (Float(offset)+firstRange)/(firstRange+secondRange);
            
            let interpolatedVector1 = AttributedVector.linearInterpolate(verticeSet[1], second: verticeSet[2], alpha: alpha1)
            let interpolatedVector2 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[2], alpha: alpha2)
            
            rasterHorizontalLine(interpolatedVector1, interpolatedVector2, locationsAreInScreenSpace: locationsAreInScreenSpace)
        }
    }
    
    func calculateAlphaForLocation(location: FloatType, rangeBegin: FloatType, rangeEnd: FloatType) -> FloatType {
        return (location - rangeBegin) / (rangeEnd - rangeBegin)
    }
    
    func rasterHorizontalLine(start: AttributedVector, _ end: AttributedVector, locationsAreInScreenSpace: Bool) {
        
        if (end.location.x < start.location.x) {
            return rasterHorizontalLine(end, start, locationsAreInScreenSpace: locationsAreInScreenSpace)
        }
        
        let startX = Int(round(start.location.x))
        let endX   = Int(round(end.location.x))
        
        let startAlpha = calculateAlphaForLocation(FloatType(startX), rangeBegin: start.location.x, rangeEnd: end.location.x)
        let endAlpha = calculateAlphaForLocation(FloatType(endX), rangeBegin: start.location.x, rangeEnd: end.location.x)
        
        let alphaIncrement = (endAlpha - startAlpha) / FloatType(endX - startX)
        
        var currentAlpha = startAlpha
        
        for _ in startX...endX {
            let alphaToUse = min(1.0, max(0.0, currentAlpha))
            let vectorAtX = AttributedVector.linearInterpolate(start, second: end, alpha: alphaToUse)
            
            drawVec(vectorAtX, shader: self.fragmentShader, locationsAreInScreenSpace: locationsAreInScreenSpace)
            
            currentAlpha += alphaIncrement
        }
    }
}