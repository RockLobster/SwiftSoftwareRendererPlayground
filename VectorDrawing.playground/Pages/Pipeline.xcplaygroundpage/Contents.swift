//: [Previous](@previous)

import AppKit
import RenderingBase

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
    
    let imageView = NSImageView(frame: CGRectMake(0, 0, 400, 400))
    imageView.imageScaling = NSImageScaling.ScaleAxesIndependently
    
    let bitmap = Bitmap(width: 400, height: 400)
    let boundingBox = model.boundingBox!
    let projectionMatrix = boundingBox.calculateBestProjectionMatrixForTargetAspectRatio(bitmap.aspectRatio, zoomFactor: 1.01)
    let vertexShader = SimpleProjectionShader(projectionMatrix)
    
    func renderUsingRasterer(rasterer: TriangleRasterer, cullBackfaces: Bool) -> NSImage? {
        bitmap.clearWithBlack()
        model.renderUsingVertexShader(vertexShader, rasterer: rasterer, cullBackFaces: cullBackfaces)
        return bitmap.createNSImage()
    }
    
    imageView.image = renderUsingRasterer( PointCloudRasterer(target: bitmap, pointColor: Color.White()), cullBackfaces: false)
    
    imageView.image = renderUsingRasterer( WireframeRasterer(target: bitmap, lineColor: Color.Green()), cullBackfaces: false)
    
    //imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: DefaultColorShader), cullBackfaces: true)
    
    imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: LocationBasedFragmentShader(boundingBox.depth * 1.0)), cullBackfaces: false)
    
    imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: LocationBasedFragmentShader(boundingBox.depth * 1.0)), cullBackfaces: true)
}

//: [Next](@next)
