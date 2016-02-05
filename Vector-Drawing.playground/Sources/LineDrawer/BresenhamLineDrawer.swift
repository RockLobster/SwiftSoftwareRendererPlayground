import Foundation

public class BresenhamLineDrawer: LineDrawer {
    
    let target: Bitmap
    
    public required init(target: Bitmap) {
        self.target = target
    }
    
    func drawToPixel(x: Int, y:Int, drawColor: Color) {
        target[x, y, 0] = drawColor.red
        target[x, y, 1] = drawColor.green
        target[x, y, 2] = drawColor.blue
    }
    
    private func safeBresenham(start: Vector3D, end: Vector3D, xAndYSwizzled: Bool, color: Color) {
        
        let xDistance = (end.x-start.x)
        if(xDistance == 0) {
            drawToPixel(Int(round(start.x)), y: Int(round(start.y)), drawColor: color)
            return
        }
        
        let slope = (end.y-start.y)/xDistance
        
        let startX = Int(round(start.x))
        let endX   = Int(round(end.x))
        
        var tmpY = start.y + (start.x-Float(startX)) * slope
        
        for x in startX...endX {
            
            let y = Int(round(tmpY))
            tmpY += slope
            
            if(xAndYSwizzled) {
                drawToPixel(y, y: x, drawColor: color)
            }
            else {
                drawToPixel(x, y: y, drawColor: color)
            }
        }
    }
    
    public func drawLine(var start: Vector3D, var end: Vector3D, color: Color) {
        
        let isSteep = abs(end.y-start.y) > abs(end.x-start.x)
        if (isSteep) {
            start = Vector3D(start.y, start.x, 0)
            end   = Vector3D(end.y,   end.x,   0)
        }
        
        if (end.x < start.x) {
            let tmp = start
            start   = end
            end     = tmp
        }
        
        return safeBresenham(start, end: end, xAndYSwizzled: isSteep, color: color)
    }
}