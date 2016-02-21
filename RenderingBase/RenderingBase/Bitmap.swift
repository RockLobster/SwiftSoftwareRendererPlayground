import Foundation
import CoreGraphics

public class Bitmap {
    public let width: Int
    public let height: Int
    let data: UnsafeMutablePointer<Void>
    let context: CGContext
    let bytesPerRow: Int
    let bytesPerPixel: Int
    let bitsPerComponent = 8
    
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
    
    private func indexIsValidForX(x: Int, y: Int, byte: Int) -> Bool {
        return x >= 0 && x < width
            && y >= 0 && y < height
            && byte >= 0 && byte < bytesPerPixel
    }
    
    private func offsetForPixelAtX(x: Int, y: Int) -> Int {
        let pixelIndex  = (y * width) + x
        return pixelIndex * bytesPerPixel
    }
    
    public subscript(x: Int, y: Int, byte: Int) -> UInt8 {
        
        get {
            if (indexIsValidForX(x, y: y, byte: byte)) {
                let dataPointer = UnsafeMutablePointer<UInt8>(data)
                return dataPointer[offsetForPixelAtX(x, y: y) + byte]
            }
            else {
                assert(false, "Index out of range")
                return 0
            }
        }
        set {
            if (indexIsValidForX(x, y: y, byte: byte)) {
                let dataPointer = UnsafeMutablePointer<UInt8>(data)
                dataPointer[offsetForPixelAtX(x, y: y) + byte] = newValue
            }
            else {
                assert(false, "Index out of range")
            }
        }
    }
}

extension Bitmap {
    public func pixelCoordinatesForEyeSpaceVector(vector: Vector3D) -> Point {
        let x = round((vector.x + 1.0) / 2 * FloatType(width))
        let y = round((vector.y + 1.0) / 2 * FloatType(height))
        return Point(x, y)
    }
}

extension Bitmap {
    public var aspectRatio: FloatType {
        return FloatType(width)/FloatType(height)
    }
}