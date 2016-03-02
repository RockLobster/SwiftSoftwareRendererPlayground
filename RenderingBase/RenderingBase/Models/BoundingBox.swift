import Foundation

public struct BoundingBoxRange {
    public let min: FloatType
    public let max: FloatType
    public var length: FloatType {
        return (min <= max) ? max-min : min-max
    }
    public var center: FloatType {
        return (min+max)/2
    }
    
    init?(min: FloatType, max: FloatType) {
        if min.isInfinite || max.isInfinite {
            return nil
        }
        
        self.min = min;
        self.max = max;
    }

    func alphaForValue(value: FloatType) -> FloatType {
        
        let denominator = (max - min)
        if (denominator == 0) {
            return 0
        }
        
        let alpha = (value - min) / denominator
        return alpha
    }
}

public struct BoundingBox {
    public let xRange: BoundingBoxRange
    public let yRange: BoundingBoxRange
    public let zRange: BoundingBoxRange
    public var width: FloatType {
        return xRange.length
    }
    public var height: FloatType {
        return yRange.length
    }
    public var depth: FloatType {
        return zRange.length
    }
    
    init?(xRange: BoundingBoxRange, yRange: BoundingBoxRange, zRange: BoundingBoxRange) {
        self.xRange = xRange
        self.yRange = yRange
        self.zRange = zRange
    }
}

extension BoundingBox {

    public func calculateBestProjectionMatrixForTargetAspectRatio(targetAspectRatio: FloatType, zoomFactor: FloatType = 1.0) -> Matrix4x4 {
        
        let boundingBoxAspectRatio = width/height
        
        let relativeAspectRatio = boundingBoxAspectRatio / targetAspectRatio
        
        var top    = yRange.max
        var bottom = yRange.min
        var left   = xRange.min
        var right  = xRange.max
        
        let bboxIsWiderThanBitmap = relativeAspectRatio > 1.0
        if (bboxIsWiderThanBitmap) {
            let bestProjectionHeight = height * relativeAspectRatio
            top = yRange.center + bestProjectionHeight/2
            bottom = yRange.center - bestProjectionHeight/2
            
        } else {
            let bestProjectionWidth = width / relativeAspectRatio
            right = xRange.center + bestProjectionWidth/2
            left = xRange.center - bestProjectionWidth/2
        }
        
        return Matrix4x4.orthographicProjectionMatrix(
            left * zoomFactor,
            right: right * zoomFactor,
            bottom: bottom * zoomFactor,
            top: top * zoomFactor
        )
    }
}