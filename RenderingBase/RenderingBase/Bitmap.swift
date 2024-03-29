import Foundation
import CoreGraphics

public final class Bitmap {
    public let width: Int
    public let height: Int
    public let bytesPerPixel: Int
    public let bitsPerComponent = 8
    
    private let data: UnsafeMutablePointer<Void>
    private let context: CGContext
    private let bytesPerRow: Int
    
    public init(width: Int, height: Int) {
        self.width  = width
        self.height = height
        bytesPerPixel = 4
        
        let bitsPerComponent = 8
        bytesPerRow = width * bytesPerPixel
        
        let totalBitmapBytes = bytesPerRow * height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        data = malloc(totalBitmapBytes)
        
        context = CGBitmapContextCreate(data, Int(width), Int(height), bitsPerComponent, bytesPerRow, colorSpace, CGImageAlphaInfo.NoneSkipLast.rawValue)!
    }
    
    deinit {
        free(data)
    }
    
    public func clearWithColorUsingRed(red: UInt8, green: UInt8, blue: UInt8) {
        let pixelCount = width * height
        let dataPointer = UnsafeMutablePointer<UInt8>(data)
        
        for pixelIndex in 0...pixelCount {
            let offset = pixelIndex * bytesPerPixel
            
            dataPointer[offset+0] = red
            dataPointer[offset+1] = green
            dataPointer[offset+2] = blue
        }
    }
    
    public func clearWithBlack() {
        clearWithColorUsingRed(0, green: 0, blue: 0)
    }
    
    public func createCGImage() -> CGImage? {
        return CGBitmapContextCreateImage(context)
    }
    
    private func isValidIndexWithX(x: Int, y: Int, byte: Int) -> Bool {
        if (x < 0 || x >= width) {
            print("Index out of range: x = [\(x)]")
            return false
        } else if (y < 0 || y >= height) {
            print("Index out of range: y = [\(y)]")
            return false
        } else if (byte < 0 || byte >= bytesPerPixel) {
            print("Index out of range: byte = [\(byte)]")
            return false
        } else {
            return true
        }
    }
    
    private func offsetForPixelAtX(x: Int, y: Int) -> Int {
        let pixelIndex  = ((height - 1 - y) * width) + x
        return pixelIndex * bytesPerPixel
    }
    
    public subscript(x: Int, y: Int, byte: Int) -> UInt8 {
        
        get {
            assert(isValidIndexWithX(x, y: y, byte: byte))
            let dataPointer = UnsafeMutablePointer<UInt8>(data)
            return dataPointer[offsetForPixelAtX(x, y: y) + byte]
        }
        set {
            if isValidIndexWithX(x, y: y, byte: byte) {
                let dataPointer = UnsafeMutablePointer<UInt8>(data)
                dataPointer[offsetForPixelAtX(x, y: y) + byte] = newValue
            } else {
                print("trying to write to illegal coordinate x: [\(x)] y: [\(y)] byte: [\(byte)]")
            }
        }
    }
}

extension Bitmap {
    public func pixelCoordinatesForNormalizedDeviceCoordinate(vector: Vector3D) -> Point {
        let x = round((vector.x + 1.0) / 2 * FloatType(width-1))
        let y = round((vector.y + 1.0) / 2 * FloatType(height-1))
        return Point(x, y)
    }
    
    public func normalizedDeviceCoordinate(vector: Vector3D) -> Vector3D {
        let x = (vector.x * 2.0 / FloatType(width)) - 1.0
        let y = (vector.y * 2.0 / FloatType(height)) - 1.0
        return Vector3D(x, y, vector.z)
    }
}

extension Bitmap {
    public var aspectRatio: FloatType {
        return FloatType(width)/FloatType(height)
    }
}