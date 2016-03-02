import Foundation
import UIKit

extension Bitmap {
    public func createUIImage() -> UIImage? {
        return UIImage(CGImage: createCGImage()!, scale: 2.0, orientation: UIImageOrientation.Up)
    }
}