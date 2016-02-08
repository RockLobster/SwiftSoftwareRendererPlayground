import Foundation

public struct BoundingBoxRange {
    public let min: FloatType
    public let max: FloatType
    
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
    
    init?(xRange: BoundingBoxRange?, yRange: BoundingBoxRange?, zRange: BoundingBoxRange?) {
        guard let xRange = xRange, let yRange = yRange, let zRange = zRange else {
            return nil
        }
        
        self.xRange = xRange
        self.yRange = yRange
        self.zRange = zRange
    }
}