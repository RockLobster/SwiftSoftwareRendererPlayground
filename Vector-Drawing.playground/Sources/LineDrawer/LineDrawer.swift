import Foundation

public protocol LineDrawer {
    
    init(target: Bitmap)
    
    func drawLine(start: Vector3D, end: Vector3D, color: Color)
}