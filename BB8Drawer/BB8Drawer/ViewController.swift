//
//  ViewController.swift
//  BB8Drawer
//
//  Created by Rainer Schlönvoigt on 02/03/16.
//  Copyright © 2016 Rainer Schlönvoigt. All rights reserved.
//

import Cocoa
import RenderingBase

class ViewController: NSViewController {

    @IBOutlet private var imageView: NSImageView?
    @IBOutlet private var loadingLabel: NSTextField?
    
    private let bitmap = Bitmap(width: 600, height: 600)
    private var model: TriangleModel?
    private let degreesPerSecond: FloatType = 20.0
    private var vertexShader: VertexShader?
    private var startTime: CFTimeInterval = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingLabel?.hidden = false
        loadModel()
        loadingLabel?.hidden = true
        
        let boundingBox = model!.boundingBox!
        
        let projectionMatrix = boundingBox.calculateBestProjectionMatrixForTargetAspectRatio(bitmap.aspectRatio, zoomFactor: 1.01)
        vertexShader = SimpleProjectionShader(projectionMatrix)
        
        startTime = CACurrentMediaTime()
        loop()
    }
    
    private func loop() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            
            let timeSpan = FloatType(CACurrentMediaTime() - self.startTime)
            
            let lightDirection = Matrix4x4.yRotationMatrixFor(self.degreesPerSecond * timeSpan, inRadians: false) * Vector3D(1, 0, 0)
            
            let rasterer = FillingRasterer(target: self.bitmap, fragmentShader: SimplePhongShaderForLightPosition(lightDirection))
            
            self.model?.renderUsingVertexShader(self.vertexShader!, rasterer: rasterer, cullBackFaces: true)
            let renderResult = self.bitmap.createNSImage()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView?.image = renderResult
                self.loop()
            };
        }
    }
    
    private func loadModel() {
        self.model = loadFileWithName("bb8")
    }

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
}

