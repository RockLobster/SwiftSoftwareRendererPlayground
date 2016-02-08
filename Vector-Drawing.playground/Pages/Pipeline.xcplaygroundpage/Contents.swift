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
    
    let bitmap = Bitmap(width: 100, height: 100)
    
    var rasterer: TriangleRasterer = WireframeRasterer(target: bitmap, lineColor: Color.Green())
    
    bitmap.clearWithBlack()
    model.renderUsing(rasterer)
    imageView.image = bitmap.createUIImage()
    
    rasterer = FillingRasterer(target: bitmap, fragmentShader: model.boundingBoxLocationFragmentShader())

    bitmap.clearWithBlack()
    model.renderUsing(rasterer)
    imageView.image = bitmap.createUIImage()
}

//: [Next](@next)
