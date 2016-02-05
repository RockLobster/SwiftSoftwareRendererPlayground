import Foundation

public protocol LinearInterpolatable {
    
    static func linearInterpolate (first: Self, second: Self, alpha: FloatType) -> Self
}

extension FloatType : LinearInterpolatable {
    public static func linearInterpolate (first: FloatType, second: FloatType, alpha: FloatType) -> FloatType {
        return (1 - alpha) * first + alpha * second
    }
}

extension UInt8 : LinearInterpolatable {
    public static func linearInterpolate(first: UInt8, second: UInt8, alpha: FloatType) -> UInt8 {
        return UInt8( round( Float.linearInterpolate(FloatType(first), second: FloatType(second), alpha: alpha)))
    }
}

extension Vector3D : LinearInterpolatable {
    public static func linearInterpolate (first: Vector3D, second: Vector3D, alpha: FloatType) -> Vector3D {
        return first.linearInterpolatedWith(second, alpha: alpha)
    }
    
    public static func linearInterpolate(first: Vector3D?, second: Vector3D?, alpha: FloatType) -> Vector3D? {
        guard let firstUnwrapped = first, let secondUnwrapped = second else {
            return nil;
        }
        
        return Vector3D.linearInterpolate(firstUnwrapped, second: secondUnwrapped, alpha: alpha)
    }
}

extension Color : LinearInterpolatable {
    public static func linearInterpolate(first: Color, second: Color, alpha: FloatType) -> Color {
        return Color(
            red: UInt8.linearInterpolate(first.red, second: second.red, alpha: alpha),
            green: UInt8.linearInterpolate(first.green, second: second.green, alpha: alpha),
            blue: UInt8.linearInterpolate(first.blue, second: second.blue, alpha: alpha))
    }
    
    public static func linearInterpolate(first: Color?, second: Color?, alpha: FloatType) -> Color? {
        guard let firstUnwrapped = first, let secondUnwrapped = second else {
            return nil
        }
        
        return Color.linearInterpolate(firstUnwrapped, second: secondUnwrapped, alpha: alpha)
    }
}

extension AttributedVector : LinearInterpolatable {
    public static func linearInterpolate(first: AttributedVector, second: AttributedVector, alpha: FloatType) -> AttributedVector {
        return AttributedVector(
            Vector3D.linearInterpolate(first.location, second: second.location, alpha: alpha),
            Color.linearInterpolate(first.color, second: second.color, alpha: alpha),
            Vector3D.linearInterpolate(first.normal, second: second.normal, alpha: alpha)
        )
    }
}