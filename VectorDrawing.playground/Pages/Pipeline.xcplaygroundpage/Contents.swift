//: [Previous](@previous)

import AppKit
import RenderingBase

private func loadFileWithName(name: String) -> TriangleModel? {
    
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

func loadBB8() -> TriangleModel? {
    return loadFileWithName("BB8/bb8")
}

func loadColorCube() -> TriangleModel? {
    return ColorCube()
}

let model = loadBB8()
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
    
    imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: LocationBasedFragmentShader(boundingBox.depth * 1.0)), cullBackfaces: false)
    
    imageView.image = renderUsingRasterer( FillingRasterer(target: bitmap, fragmentShader: LocationBasedFragmentShader(boundingBox.depth * 1.0)), cullBackfaces: true)
}

//: [Next](@next)
