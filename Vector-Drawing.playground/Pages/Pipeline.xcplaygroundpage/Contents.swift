//: [Previous](@previous)

import UIKit

func loadModel() -> TriangleModel? {
    
    guard let modelPath = NSBundle.mainBundle().pathForResource("BB8/bb8", ofType: "obj") else {
        print("Can't find model file")
        return nil
    }
    
    guard let streamReader = StreamReader(fileHandle: NSFileHandle(forReadingAtPath: modelPath)!) else {
        print("Can't read from file")
        return nil
    }
    
    return ObjLoader().readModelFromFile(streamReader)
}

let model = loadModel()

if let model = model {
    assert(model.faceIndices.count % 3 == 0)
    
    let imageView = UIImageView(frame: CGRectMake(0, 0, 400, 400))
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    imageView.layer.magnificationFilter = kCAFilterNearest
    imageView.layer.minificationFilter  = kCAFilterNearest
    
    let bitmap = Bitmap(width: 200, height: 200)
    let boundingBox = model.boundingBox!
    let projectionMatrix = boundingBox.calculateBestProjectionMatrixForTargetAspectRatio(bitmap.aspectRatio)
    let vertexShader = SimpleProjectionShader(projectionMatrix)
    
    func renderUsingRasterer(rasterer: TriangleRasterer) -> UIImage? {
        bitmap.clearWithBlack()
        model.renderUsing(vertexShader, rasterer: rasterer)
        return bitmap.createUIImage()
    }
    
    imageView.image = renderUsingRasterer( PointCloudRasterer(target: bitmap, pointColor: Color.White()) )
    
    imageView.image = renderUsingRasterer( WireframeRasterer(target: bitmap, lineColor: Color.Green()) )
    
    imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: LocationBasedFragmentShader(boundingBox.depth)) )
}

//: [Next](@next)
