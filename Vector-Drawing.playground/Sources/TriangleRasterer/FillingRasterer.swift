import Foundation

public class FillingRasterer : TriangleRasterer {
    
    let target: Bitmap
    let lineDrawer: LineDrawer
    
    public required init(target: Bitmap) {
        self.target = target
        self.lineDrawer = BresenhamLineDrawer(target: target)
    }
    
    func drawToPixel(x: Int, y:Int, drawColor: Color) {
        target[x, y, 0] = drawColor.red
        target[x, y, 1] = drawColor.green
        target[x, y, 2] = drawColor.blue
    }
    
    func drawToPixel(x: Float, y: Float, drawColor: Color) {
        self.drawToPixel(Int(round(x)), y: Int(round(y)), drawColor: drawColor);
    }
    
    func drawVec(vector: AttributedVector, shader: FragmentShader) {
        let optionalFragmentColor = shader(vector)
        
        if let fragmentColor = optionalFragmentColor {
            drawToPixel(vector.location.x, y: vector.location.y, drawColor: fragmentColor)
        }
    }
    
    public func rasterTriangle(vertice1: AttributedVector, vertice2: AttributedVector, vertice3: AttributedVector, shader: FragmentShader) {
        var verticeSet = [vertice1, vertice2, vertice3]
        
        verticeSet.sortInPlace { return $0.location.y < $1.location.y }
        let firstRange  = verticeSet[1].location.y - verticeSet[0].location.y;
        let secondRange = verticeSet[2].location.y - verticeSet[1].location.y;
        
        drawVec(verticeSet[0], shader: shader)
        drawVec(verticeSet[1], shader: shader)
        drawVec(verticeSet[2], shader: shader)
        
        for offset in 1..<Int(ceil(firstRange)) {
            let alpha1 = Float(offset)/firstRange;
            let alpha2 = Float(offset)/(firstRange+secondRange);
            
            let interpolatedVector1 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[1], alpha: alpha1)
            let interpolatedVector2 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[2], alpha: alpha2)
            
            rasterHorizontalLine(interpolatedVector1, interpolatedVector2, shader: shader)
        }
        for offset in 0..<Int(ceil(secondRange)) {
            let alpha1 = Float(offset)/secondRange;
            let alpha2 = (Float(offset)+firstRange)/(firstRange+secondRange);
            
            let interpolatedVector1 = AttributedVector.linearInterpolate(verticeSet[1], second: verticeSet[2], alpha: alpha1)
            let interpolatedVector2 = AttributedVector.linearInterpolate(verticeSet[0], second: verticeSet[2], alpha: alpha2)
            
            rasterHorizontalLine(interpolatedVector1, interpolatedVector2, shader: shader)
        }
    }
    
    func calculateAlphaForLocation(location: FloatType, rangeBegin: FloatType, rangeEnd: FloatType) -> FloatType {
        return (location - rangeBegin) / (rangeEnd - rangeBegin)
    }
    
    func rasterHorizontalLine(start: AttributedVector, _ end: AttributedVector, shader: FragmentShader) {
        
        if (end.location.x < start.location.x) {
            return rasterHorizontalLine(end, start, shader: shader)
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
            
            drawVec(vectorAtX, shader: shader)
            
            currentAlpha += alphaIncrement
        }
    }
}