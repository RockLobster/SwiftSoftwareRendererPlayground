import Foundation

public typealias FloatType = Float

func degreesToRadian(degrees: FloatType) -> FloatType {
    return FloatType(Double(degrees)*M_PI/180.0)
}