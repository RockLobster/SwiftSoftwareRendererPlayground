//: Playground - noun: a place where people can play

import UIKit
import RenderingBase

let imageView = UIImageView(frame: CGRectMake(0, 0, 400, 400))
imageView.contentMode = UIViewContentMode.ScaleAspectFit
imageView.layer.magnificationFilter = kCAFilterNearest
imageView.layer.minificationFilter  = kCAFilterNearest

let bitmap = Bitmap(width: 100, height: 100)

bitmap.clearWithBlack()
let lineDrawer = BresenhamLineDrawer(target: bitmap)
lineDrawer.drawLine(Point(0, 20), end: Point(Float(bitmap.width-1), Float(20)), color: Color.Green())
lineDrawer.drawLine(Point(20, 0), end: Point(Float(20), Float(bitmap.height-1)), color: Color.Green())
lineDrawer.drawLine(Point(0, 0),  end: Point(Float(bitmap.width-1), Float(bitmap.height/2-1)), color: Color.White())
lineDrawer.drawLine(Point(50,60), end: Point(50,60), color: Color.Green())
lineDrawer.drawLine(Point(0, 0),  end: Point(99, 99), color: Color.Blue())
lineDrawer.drawLine(Point(0, 99), end: Point(99, 70), color: Color.Red())
imageView.image = bitmap.createUIImage()

//Triangle 1
let triangle1 = [
    AttributedVector(Vector3D(10, 10), Color.Red(), nil),
    AttributedVector(Vector3D(20, 90), Color.Green(), nil),
    AttributedVector(Vector3D(80, 30), Color.Blue(), nil)
]

//Triangle 2
let triangle2 = [
    AttributedVector(Vector3D(90, 10), Color.Red(), nil),
    AttributedVector(Vector3D(90, 90), Color.Green(), nil),
    AttributedVector(Vector3D(130, 30), Color.Blue(), nil)
]

//Triangle 3
let triangle3 = [
    AttributedVector(Vector3D(10, 90), Color.Red(), nil),
    AttributedVector(Vector3D(10, 70), Color.Green(), nil),
    AttributedVector(Vector3D(-39, 30), Color.Blue(), nil)
]

//Triangle 4
let triangle4 = [
    AttributedVector(Vector3D(-2.6071, 131.224, -10.3267), Color.Red(), nil),
    AttributedVector(Vector3D(-1.3369, 129.913, -12.1076), Color.Green(), nil),
    AttributedVector(Vector3D(-2.5856, 129.913, -12.9089), Color.Blue(), nil)
]

func render(triangle: [AttributedVector], rasterer: TriangleRasterer) {
    triangleRasterer.rasterTriangle(triangle[0], vertice2: triangle[1], vertice3: triangle[2], locationsAreInNormalizedDeviceCoordinates: false)
}

var triangleRasterer: TriangleRasterer
triangleRasterer = WireframeRasterer(target: bitmap, lineColor: Color.Green())

bitmap.clearWithBlack()
render(triangle1, rasterer: triangleRasterer)
render(triangle2, rasterer: triangleRasterer)
render(triangle3, rasterer: triangleRasterer)
//render(triangle4, rasterer: triangleRasterer)
imageView.image = bitmap.createUIImage()

triangleRasterer = FillingRasterer(target: bitmap, fragmentShader: DefaultColorShader)

bitmap.clearWithBlack()
render(triangle1, rasterer: triangleRasterer)
render(triangle2, rasterer: triangleRasterer)
render(triangle3, rasterer: triangleRasterer)
//render(triangle4, rasterer: triangleRasterer)
imageView.image = bitmap.createUIImage()
