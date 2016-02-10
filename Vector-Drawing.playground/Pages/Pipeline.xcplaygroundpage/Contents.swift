//: [Previous](@previous)

import UIKit

func loadModel() -> TriangleModel? {
    
    let name = "BB8/bb8"
//    let name = "house interior"
    
    guard let modelPath = NSBundle.mainBundle().pathForResource(name, ofType: "obj") else {
        print("Can't find model file")
        return nil
    }
    
    guard let streamReader = StreamReader(fileHandle: NSFileHandle(forReadingAtPath: modelPath)!) else {
        print("Can't read from file")
        return nil
    }
    
    return ObjLoader().readModelFromFile(streamReader)
}

func loadColorCube() -> TriangleModel? {
    return ColorCube()
}

let model = loadModel()
//let model = loadColorCube()

if let model = model {
    assert(model.faceIndices.count % 3 == 0)
    
    let imageView = UIImageView(frame: CGRectMake(0, 0, 400, 400))
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    imageView.layer.magnificationFilter = kCAFilterNearest
    imageView.layer.minificationFilter  = kCAFilterNearest
    
    let bitmap = Bitmap(width: 200, height: 200)
    let boundingBox = model.boundingBox!
    let projectionMatrix = boundingBox.calculateBestProjectionMatrixForTargetAspectRatio(bitmap.aspectRatio, zoomFactor: 1.0)
    let vertexShader = SimpleProjectionShader(projectionMatrix)
    
    func renderUsingRasterer(rasterer: TriangleRasterer, cullBackfaces: Bool) -> UIImage? {
        bitmap.clearWithBlack()
        model.renderUsingVertexShader(vertexShader, rasterer: rasterer, cullBackFaces: cullBackfaces)
        return bitmap.createUIImage()
    }
    
    imageView.image = renderUsingRasterer( PointCloudRasterer(target: bitmap, pointColor: Color.White()), cullBackfaces: false)
    
    imageView.image = renderUsingRasterer( WireframeRasterer(target: bitmap, lineColor: Color.Green()), cullBackfaces: false)
    
    imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: LocationBasedFragmentShader(boundingBox.depth)), cullBackfaces: false)
    
    imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: LocationBasedFragmentShader(boundingBox.depth)), cullBackfaces: true)
    
}

//: [Next](@next)
