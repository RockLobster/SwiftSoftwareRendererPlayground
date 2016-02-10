import Foundation

/**
 * A cube that gets:
 * - more red with growing x
 * - more blue with growing y
 * - less green with growing z
 */
public class ColorCube: TriangleModel {
    
    public override init() {
        super.init()
    
        self.geometricVertices = [
            Vector3D(0,0,0),
            Vector3D(1,0,0),
            Vector3D(0,1,0),
            Vector3D(1,1,0),
            Vector3D(0,0,1),
            Vector3D(1,0,1),
            Vector3D(0,1,1),
            Vector3D(1,1,1)
        ]
        
        func vertexToColor(vector: Vector3D) -> Color {
            return Color(
                red:   UInt8(vector.x     * 255),
                green: UInt8((1-vector.z) * 255),
                blue:  UInt8(vector.y     * 255)
            )
        }
        
        self.colors = self.geometricVertices.map {
            return vertexToColor($0)
        }
        
        self.faceIndices = [
            //Front
            FaceVertexIndices(vertexIndex: 0, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 1, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 3, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 0, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 3, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 2, textureIndex: nil, normalIndex: nil),
            
            //Right
            FaceVertexIndices(vertexIndex: 1, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 5, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 7, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 1, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 7, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 3, textureIndex: nil, normalIndex: nil),
            
            //Left
            FaceVertexIndices(vertexIndex: 4, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 0, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 2, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 4, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 2, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 6, textureIndex: nil, normalIndex: nil),
            
            //Top
            FaceVertexIndices(vertexIndex: 2, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 3, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 7, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 2, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 7, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 6, textureIndex: nil, normalIndex: nil),
            
            //Bottom
            FaceVertexIndices(vertexIndex: 5, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 4, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 0, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 5, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 0, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 1, textureIndex: nil, normalIndex: nil),
            
            //Back
            FaceVertexIndices(vertexIndex: 5, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 4, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 6, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 5, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 6, textureIndex: nil, normalIndex: nil),
            FaceVertexIndices(vertexIndex: 7, textureIndex: nil, normalIndex: nil),
        ]
    }
}