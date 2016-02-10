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
    
    init?(xRange: BoundingBoxRange?, yRange: BoundingBoxRange?, zRange: BoundingBoxRange?) {
        guard let xRange = xRange, let yRange = yRange, let zRange = zRange else {
            return nil
        }
        
        self.xRange = xRange
        self.yRange = yRange
        self.zRange = zRange
    }
}

extension BoundingBox {

    public func calculateBestProjectionMatrixForTargetAspectRatio(targetAspectRatio: FloatType) -> Matrix4x4 {
        
        let boundingBoxAspectRatio = width/height
        
        let relativeAspectRatio = boundingBoxAspectRatio / targetAspectRatio
        
        let bboxIsWiderThanBitmap = relativeAspectRatio > 1.0
        if (bboxIsWiderThanBitmap) {
            print("BBox is wider")
            let bestProjectionHeight = height * relativeAspectRatio
            let top = yRange.center + bestProjectionHeight/2
            let bottom = yRange.center - bestProjectionHeight/2
            
            return Matrix4x4.orthographicProjectionMatrix(
                xRange.min,
                right: xRange.max,
                bottom: bottom,
                top: top)
            
        } else {
            print("BBox is narrower")
            
            let bestProjectionWidth = width / relativeAspectRatio
            let right = xRange.center + bestProjectionWidth/2
            let left = xRange.center - bestProjectionWidth/2
            
            return Matrix4x4.orthographicProjectionMatrix(
                left,
                right: right,
                bottom: yRange.min,
                top: yRange.max)
        }
    }
}