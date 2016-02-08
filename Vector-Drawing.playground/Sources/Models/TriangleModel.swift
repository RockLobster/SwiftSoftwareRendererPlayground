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

public class TriangleModel {
    
    public var geometricVertices = [Vector3D]()
    public var textureCoordinates = [Vector3D]()
    public var normals = [Vector3D]()
    public var faceIndices = [FaceVertexIndices]()
    public var boundingBox: BoundingBox? {
        
        let minX = self.geometricVertices.reduce(Float.infinity, combine:{return min($0, $1.x)})
        let maxX = self.geometricVertices.reduce(-Float.infinity, combine:{return max($0, $1.x)})
        let minY = self.geometricVertices.reduce(Float.infinity, combine:{return min($0, $1.y)})
        let maxY = self.geometricVertices.reduce(-Float.infinity, combine:{return max($0, $1.y)})
        let minZ = self.geometricVertices.reduce(Float.infinity, combine:{return min($0, $1.z)})
        let maxZ = self.geometricVertices.reduce(-Float.infinity, combine:{return max($0, $1.z)})
        
        return BoundingBox(
            xRange: BoundingBoxRange(min: minX, max: maxX),
            yRange: BoundingBoxRange(min: minY, max: maxY),
            zRange: BoundingBoxRange(min: minZ, max: maxZ)
        )
    }
    
    func attributedVectorFor(indices: FaceVertexIndices) -> AttributedVector {
        let location = geometricVertices[indices.vertexIndex]
        var normal: Vector3D? = nil
        if let normalIndex = indices.normalIndex {
            normal = normals[normalIndex]
        }
        
        return AttributedVector(location, nil, normal)
    }
}

extension TriangleModel {
    
    public func boundingBoxLocationFragmentShader() -> FragmentShader {
        
        let boundingBox = self.boundingBox
        
        return {
            return Color(
                red: UInt8(alphaForValueInRange($0.location.x, range: boundingBox!.xRange) * 255),
                green: UInt8(alphaForValueInRange($0.location.y, range: boundingBox!.yRange) * 255),
                blue: UInt8(alphaForValueInRange($0.location.z, range: boundingBox!.zRange) * 255)
            )
        }
    }
    
    public func renderUsing(rasterer: TriangleRasterer) {
        for i in 0..<self.faceIndices.count/3 {
            
            let vertex1 = self.attributedVectorFor(self.faceIndices[i * 3 + 0])
            let vertex2 = self.attributedVectorFor(self.faceIndices[i * 3 + 1])
            let vertex3 = self.attributedVectorFor(self.faceIndices[i * 3 + 2])
            
//            print("Triangle \(i)")
//            print(vertex1)
//            print(vertex2)
//            print(vertex3)
            
            rasterer.rasterTriangle(vertex1,
                vertice2: vertex2,
                vertice3: vertex3)
        }
    }
}