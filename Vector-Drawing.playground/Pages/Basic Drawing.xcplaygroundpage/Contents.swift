//: Playground - noun: a place where people can play

import UIKit

let imageView = UIImageView(frame: CGRectMake(0, 0, 400, 400))
imageView.contentMode = UIViewContentMode.ScaleAspectFit
imageView.layer.magnificationFilter = kCAFilterNearest
imageView.layer.minificationFilter  = kCAFilterNearest

let bitmap = Bitmap(width: 100, height: 100)

bitmap.clearWithBlack()
let lineDrawer = BresenhamLineDrawer(target: bitmap)
lineDrawer.drawLine(Vector3D(0, 20), end: Vector3D(Float(bitmap.width-1), Float(20)), color: Color.Green())
lineDrawer.drawLine(Vector3D(20, 0), end: Vector3D(Float(20), Float(bitmap.height-1)), color: Color.Green())
lineDrawer.drawLine(Vector3D(0, 0),  end: Vector3D(Float(bitmap.width-1), Float(bitmap.height/2-1)), color: Color.White())
lineDrawer.drawLine(Vector3D(50,60), end: Vector3D(50,60), color: Color.Green())
lineDrawer.drawLine(Vector3D(0, 0),  end: Vector3D(99, 99), color: Color.Blue())
lineDrawer.drawLine(Vector3D(0, 99), end: Vector3D(99, 70), color: Color.Red())
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

var triangleRasterer: TriangleRasterer
triangleRasterer = WireframeRasterer(target: bitmap)

bitmap.clearWithBlack()
triangleRasterer.rasterTriangle(triangle1[0], vertice2: triangle1[1], vertice3: triangle1[2], shader: {$0.color})
triangleRasterer.rasterTriangle(triangle2[0], vertice2: triangle2[1], vertice3: triangle2[2], shader: {$0.color})
triangleRasterer.rasterTriangle(triangle3[0], vertice2: triangle3[1], vertice3: triangle3[2], shader: {$0.color})
imageView.image = bitmap.createUIImage()


triangleRasterer = FillingRasterer(target: bitmap)

bitmap.clearWithBlack()
triangleRasterer.rasterTriangle(triangle1[0], vertice2: triangle1[1], vertice3: triangle1[2], shader: {$0.color})
triangleRasterer.rasterTriangle(triangle2[0], vertice2: triangle2[1], vertice3: triangle2[2], shader: {$0.color})
triangleRasterer.rasterTriangle(triangle3[0], vertice2: triangle3[1], vertice3: triangle3[2], shader: {$0.color})
imageView.image = bitmap.createUIImage()





