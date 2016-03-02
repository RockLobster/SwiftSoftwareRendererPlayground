//: [Previous](@previous)

import Foundation
import AppKit
import RenderingBase

let imageView = NSImageView(frame: CGRectMake(0, 0, 400, 400))
imageView.imageScaling = NSImageScaling.ScaleAxesIndependently

let bitmap = Bitmap(width: 100, height: 100)

let triangleOutsideLeft = [
    AttributedVector(Vector3D(-15, 10), Color.Red(), nil),
    AttributedVector(Vector3D(-50, 90), Color.Green(), nil),
    AttributedVector(Vector3D(-26, 30), Color.Blue(), nil)
]

let triangleOutsideRight = [
    AttributedVector(Vector3D(190, 10), Color.Red(), nil),
    AttributedVector(Vector3D(100, 90), Color.Green(), nil),
    AttributedVector(Vector3D(130, 30), Color.Blue(), nil)
]

let triangleOutsideBottom = [
    AttributedVector(Vector3D(12, -38), Color.Red(), nil),
    AttributedVector(Vector3D(83, -83), Color.Green(), nil),
    AttributedVector(Vector3D(63, -44), Color.Blue(), nil)
]

let triangleOutsideTop = [
    AttributedVector(Vector3D(10, 190), Color.Red(), nil),
    AttributedVector(Vector3D(90, 100), Color.Green(), nil),
    AttributedVector(Vector3D(30, 130), Color.Blue(), nil)
]

let triangleRasterer = FillingRasterer(target: bitmap, fragmentShader: DefaultColorShader)
func render(triangle: [AttributedVector], locationsAreInNormalizedDeviceCoordinates: Bool) {
    triangleRasterer.rasterTriangle(triangle[0], vertice2: triangle[1], vertice3: triangle[2], locationsAreInNormalizedDeviceCoordinates: locationsAreInNormalizedDeviceCoordinates)
}

bitmap.clearWithBlack()
render(triangleOutsideLeft, locationsAreInNormalizedDeviceCoordinates: false)
render(triangleOutsideRight, locationsAreInNormalizedDeviceCoordinates: false)
render(triangleOutsideBottom, locationsAreInNormalizedDeviceCoordinates: false)
render(triangleOutsideTop, locationsAreInNormalizedDeviceCoordinates: false)
imageView.image = bitmap.createNSImage()


let trianglePartiallyOutsideLeft = [
    AttributedVector(Vector3D(-1.5, -1.0), Color.Red(), nil),
    AttributedVector(Vector3D(-1.5, 1.0), Color.Green(), nil),
    AttributedVector(Vector3D(-0.5, 0), Color.Blue(), nil)
]

let trianglePartiallyOutsideRight = [
    AttributedVector(Vector3D(1.5, -1.0), Color.Red(), nil),
    AttributedVector(Vector3D(1.5, 1.0), Color.Green(), nil),
    AttributedVector(Vector3D(0.5, 0), Color.Blue(), nil)
]

let trianglePartiallyOutsideBottom = [
    AttributedVector(Vector3D(-1.0, -1.5), Color.Red(), nil),
    AttributedVector(Vector3D(1.0, -1.5), Color.Green(), nil),
    AttributedVector(Vector3D(0, -0.5), Color.Blue(), nil)
]

let trianglePartiallyOutsideTop = [
    AttributedVector(Vector3D(-1.0, 1.5), Color.Red(), nil),
    AttributedVector(Vector3D(1.0, 1.5), Color.Green(), nil),
    AttributedVector(Vector3D(0, 0.5), Color.Blue(), nil)
]

bitmap.clearWithBlack()
render(trianglePartiallyOutsideLeft, locationsAreInNormalizedDeviceCoordinates: true)
render(trianglePartiallyOutsideRight, locationsAreInNormalizedDeviceCoordinates: true)
render(trianglePartiallyOutsideBottom, locationsAreInNormalizedDeviceCoordinates: true)
render(trianglePartiallyOutsideTop, locationsAreInNormalizedDeviceCoordinates: true)
imageView.image = bitmap.createNSImage()

//: [Next](@next)
