import Foundation
import AppKit

extension Bitmap {
    public func createNSImage() -> NSImage? {
        return NSImage(CGImage: createCGImage()!, size: NSSize(width: width, height: height))
    }
}