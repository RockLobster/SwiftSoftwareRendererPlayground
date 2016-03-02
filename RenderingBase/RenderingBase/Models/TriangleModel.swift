import Foundation

public struct FaceVertexIndices {
    public var vertexIndex: Int
    public var textureIndex: Int?
    public var normalIndex: Int?
    
    public init(vertexIndex: Int, textureIndex: Int?, normalIndex: Int?) {
        self.vertexIndex = vertexIndex
        self.textureIndex = textureIndex
        self.normalIndex = normalIndex
    }
}

public enum WindingOrder {
    case Clockwise
    case CounterClockwise
}

public class TriangleModel {
    
    public var geometricVertices = [Vector3D]()
    public var textureCoordinates = [Vector3D]()
    public var colors = [Color]()
    public var normals = [Vector3D]()
    public var faceIndices = [FaceVertexIndices]()
    
    public var windingOrder: WindingOrder = WindingOrder.CounterClockwise
    
    public var boundingBox: BoundingBox? {
        
        if geometricVertices.isEmpty {
            return nil
        }
        
        let minX = self.geometricVertices.minElement {$0.x < $1.x}?.x
        let maxX = self.geometricVertices.maxElement {$0.x < $1.x}?.x
        
        let minY = self.geometricVertices.minElement {$0.y < $1.y}?.y
        let maxY = self.geometricVertices.maxElement {$0.y < $1.y}?.y
        
        let minZ = self.geometricVertices.minElement {$0.z < $1.z}?.z
        let maxZ = self.geometricVertices.maxElement {$0.z < $1.z}?.z
        
        let xRange = BoundingBoxRange(min: minX!, max: maxX!)!
        let yRange = BoundingBoxRange(min: minY!, max: maxY!)!
        let zRange = BoundingBoxRange(min: minZ!, max: maxZ!)!
        
        return BoundingBox(
            xRange: xRange,
            yRange: yRange,
            zRange: zRange
        )
    }
}

extension TriangleModel {
    
    private func attributedVectorFor(indices: FaceVertexIndices) -> AttributedVector {
        let location = geometricVertices[indices.vertexIndex]
        var normal: Vector3D? = nil
        if let normalIndex = indices.normalIndex {
            normal = normals[normalIndex]
        }
        var color: Color? = nil
        if (colors.count > indices.vertexIndex) {
            color = colors[indices.vertexIndex]
        }
        
        return AttributedVector(location, color, normal)
    }
    
    private func windingOrderForTriangle(var vertice1: Vector3D, var vertice2: Vector3D, var vertice3: Vector3D) -> WindingOrder {
        vertice1.z = 0
        vertice2.z = 0
        vertice3.z = 0
        
        let crossProductDepth = (vertice2 - vertice1).crossProductWith(vertice3 - vertice1).z
        
        let result = (crossProductDepth > 0) ? WindingOrder.CounterClockwise : WindingOrder.Clockwise
        
        //print("Z: [\(crossProductDepth)] -> \(result)")
        
        return result
    }
    
    public func renderUsingVertexShader(vertexShader:VertexShader, rasterer: TriangleRasterer, cullBackFaces: Bool = false) {
        
        for i in 0..<self.faceIndices.count/3 {
            
            let vertex1 = vertexShader(self.attributedVectorFor(self.faceIndices[i * 3 + 0]))
            let vertex2 = vertexShader(self.attributedVectorFor(self.faceIndices[i * 3 + 1]))
            let vertex3 = vertexShader(self.attributedVectorFor(self.faceIndices[i * 3 + 2]))
            
            if (cullBackFaces && self.windingOrder != windingOrderForTriangle(vertex1.location, vertice2: vertex2.location, vertice3: vertex3.location)) {
                continue
            }
            
            rasterer.rasterTriangle(vertex1,
                vertice2: vertex2,
                vertice3: vertex3,
                locationsAreInNormalizedDeviceCoordinates: true)
        }
    }
}