import Foundation

public protocol LineDrawer {
    
    init(target: Bitmap)
    
    func drawLine(start: Point, end: Point, color: Color)
}