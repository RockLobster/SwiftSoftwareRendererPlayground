import Foundation

public struct Vector3D : CustomDebugStringConvertible {
    
    public var x : FloatType
    public var y : FloatType
    public var z : FloatType

    public var debugDescription: String {
        return "Vector x: [\(x)] y: [\(y)] z: [\(z)]"
    }
    
    public init(_ x: FloatType, _ y: FloatType) {
        self.x = x
        self.y = y
        self.z = 0.0
    }
    
    public init(_ x: FloatType, _ y: FloatType, _ z: FloatType) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(_ otherVector: Vector3D) {
        x = otherVector.x
        y = otherVector.y
        z = otherVector.z
    }
    
    public var length : FloatType {
        get {
            return sqrt(x*x + y*y + z*z)
        }
        set(newLength) {
            let currentLength = length
            if (currentLength == 0) {
                return
            }
            
            self *= (newLength/currentLength)
        }
    }
    
    public mutating func normalize() {
        let currentLength = length
        if (currentLength == 0) {
            return
        }
        self /= currentLength
    }
    
    public func normalized() -> Vector3D {
        let currentLength = length
        if (currentLength == 0) {
            return self
        }
        return self / currentLength
    }
    
    public mutating func floor() {
        x = Darwin.floor(x)
        y = Darwin.floor(y)
        z = Darwin.floor(z)
    }
    
    public func floored() -> Vector3D {
        return Vector3D(
            Darwin.floor(x),
            Darwin.floor(y),
            Darwin.floor(z))
    }
    
    public mutating func round() {
        x = Darwin.round(x)
        y = Darwin.round(y)
        z = Darwin.round(z)
    }
    
    public func rounded() -> Vector3D {
        return Vector3D(
            Darwin.round(x),
            Darwin.round(y),
            Darwin.round(z))
    }
    
    public func crossProductWith(otherVector: Vector3D) -> Vector3D {
        return Vector3D(
            (y * otherVector.z) - (z * otherVector.y),
            (z * otherVector.x) - (x * otherVector.z),
            (x * otherVector.y) - (y * otherVector.x))
    }
    
    public func dotProductWith(otherVector: Vector3D) -> FloatType {
        return x * otherVector.x
            + y * otherVector.y
            + z * otherVector.z
    }
    
    public func angleBetween(otherVector: Vector3D) -> FloatType {
        let lengthProduct = length * otherVector.length
        
        if (lengthProduct == 0.0) {
            return 0.0
        }
        
        var tmp = dotProductWith(otherVector) / lengthProduct
        tmp = max(tmp, -1.0)
        tmp = min(tmp, 1.0)
        
        return acos(tmp)
    }
    
    public func linearInterpolatedWith(otherVector: Vector3D, alpha: FloatType) -> Vector3D {
        return Vector3D(
            Float.linearInterpolate(x, second: otherVector.x, alpha: alpha),
            Float.linearInterpolate(y, second: otherVector.y, alpha: alpha),
            Float.linearInterpolate(z, second: otherVector.z, alpha: alpha)
        )
    }
}

public func - (first: Vector3D, second: Vector3D) -> Vector3D {
    return Vector3D(
        first.x - second.x,
        first.y - second.y,
        first.z - second.z)
}

public func + (first: Vector3D, second: Vector3D) -> Vector3D {
    return Vector3D(
        first.x + second.x,
        first.y + second.y,
        first.z + second.z)
}

public func * (first: Vector3D, second: FloatType) -> Vector3D {
    return Vector3D(
        first.x * second,
        first.y * second,
        first.z * second)
}

public func / (first: Vector3D, second: FloatType) -> Vector3D {
    return Vector3D(
        first.x / second,
        first.y / second,
        first.z / second)
}

public func -= (inout first: Vector3D, second: Vector3D) {
    first.x -= second.x
    first.y -= second.y
    first.z -= second.z
}

public func += (inout first: Vector3D, second: Vector3D) {
    first.x += second.x
    first.y += second.y
    first.z += second.z
}

public func *= (inout first: Vector3D, second: FloatType) {
    first.x *= second
    first.y *= second
    first.z *= second
}

public func /= (inout first: Vector3D, second: FloatType) {
    first.x /= second
    first.y /= second
    first.z /= second
}

public prefix func - (vector: Vector3D) -> Vector3D {
    return Vector3D(-vector.x, -vector.y, -vector.z)
}