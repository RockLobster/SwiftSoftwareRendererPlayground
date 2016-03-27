//: [Back to Table of Contents](@first) | [Previous](@previous)
//: ## Drawing a Triangle

import AppKit

/*: 
Before we are able to draw anything we need to have a render target
> **Hint:**
> For more details check [Drawing a Line](Drawing%20a%20Line)
*/
import RenderingBase

let bitmap = Bitmap(width: 100, height: 100)
let imageView = NSImageView(frame: CGRectMake(0, 0, 400, 400))
imageView.imageScaling = NSImageScaling.ScaleAxesIndependently
bitmap.clearWithBlack()

/*:
First we define a bunch of Triangles
> **Important:**
> Vertex Points are here still in pixel coordinates
>> **Hint:**
>> Feel free to add your own Triangle
*/

//: Triangle 1
let triangle1 = [
    AttributedVector(Vector3D(10, 10), Color.Red(), nil),
    AttributedVector(Vector3D(20, 90), Color.Green(), nil),
    AttributedVector(Vector3D(80, 30), Color.Blue(), nil)
]

//: Triangle 2
let triangle2 = [
    AttributedVector(Vector3D(90, 10), Color.Red(), nil),
    AttributedVector(Vector3D(90, 90), Color.Green(), nil),
    AttributedVector(Vector3D(130, 30), Color.Blue(), nil)
]

//: Triangle 3
let triangle3 = [
    AttributedVector(Vector3D(10, 90), Color.Red(), nil),
    AttributedVector(Vector3D(10, 70), Color.Green(), nil),
    AttributedVector(Vector3D(-39, 30), Color.Blue(), nil)
]

//: Triangle 4
let triangle4 = [
    AttributedVector(Vector3D(-2.6071, 131.224, -10.3267), Color.Red(), nil),
    AttributedVector(Vector3D(-1.3369, 129.913, -12.1076), Color.Green(), nil),
    AttributedVector(Vector3D(-2.5856, 129.913, -12.9089), Color.Blue(), nil)
]

//: For convenience let's collect all triangles in an array
let allTriangles = [triangle1, triangle2, triangle3, triangle4]

//: This is just a convenience function
func renderAllTrianglesUsingRasterer(rasterer: TriangleRasterer) -> NSImage? {
    
    bitmap.clearWithBlack()
    
    for triangle in allTriangles {
        rasterer.rasterTriangle(triangle[0], vertice2: triangle[1], vertice3: triangle[2], locationsAreInNormalizedDeviceCoordinates: false)
    }
    
    return bitmap.createNSImage()
}

//: The easiest way of drawing a triangle is by simply drawing a line between the vertices
let wireFrameRasterer = WireframeRasterer(target: bitmap, lineColor: Color.Green())
imageView.image = renderAllTrianglesUsingRasterer(wireFrameRasterer)

/*: 
Values (like color) can also be interpolated between the vertices.
The general approach is:
1. Scan the Triangle line by line (bottom-to-top or top-to-bottom)
2. For each line find the entry point and the exit point into the triangle
3. For both points interpolate their values (like color) from the vertices of the triangle
4. For every pixel that lies between the two points interpolate the values
*/
let fillingRasterer   = FillingRasterer(target: bitmap, fragmentShader: DefaultColorShader)
imageView.image = renderAllTrianglesUsingRasterer(fillingRasterer)

//: [Next page](@next)
