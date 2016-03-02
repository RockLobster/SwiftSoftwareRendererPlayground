import Foundation

public final class ObjLoader {
    
    public init () {}
    
    private var lineCount = 0
    
    public func readModelFromFile(lineSource: StreamReader) -> TriangleModel? {
    
        let model = TriangleModel()
        
        for line in lineSource {
            handleLine(line, model: model)
            lineCount++
        }
        
        return model
    }
    
    func handleLine(line: String, model: TriangleModel) {
        
        guard let splitLine = extractPrefixFrom(line) else {
            return
        }
        
        //print("line \(lineCount): \(line)")
        //print("Found a line with prefix [\(splitLine.prefix)] and value [\(splitLine.restLine)]")
        
        switch splitLine.prefix {
        case "v":
            
            if let vector = extractVectorFrom(splitLine.restLine) {
                model.geometricVertices.append(vector)
            }
            break
            
        case "vn":
            if let normal = extractVectorFrom(splitLine.restLine) {
                model.normals.append(normal)
            }
            break
            
        case "vt":
            if let textureCoordinate = extractVectorFrom(splitLine.restLine) {
                model.textureCoordinates.append(textureCoordinate)
            }
            break
            
        case "f":
            if let faceIndices = extractFaceIndicesFrom(splitLine.restLine) {
                model.faceIndices.appendContentsOf(faceIndices)
            }
            break
            
        default:
            break
        }
    }
    
    func extractPrefixFrom(line: String) -> (prefix: String, restLine: String)? {
        guard let index = line.characters.indexOf(" ") else {
            return nil
        }
        
        let prefix = line.substringToIndex(index).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let restLine = line.substringFromIndex(index).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        return (prefix, restLine)
    }
    
    func extractVectorFrom(line: String) -> Vector3D? {
        let splitCharacters = line.characters.split(" ")
        let stringyfied = splitCharacters.map(String.init)
        let scalarStrings = stringyfied.filter {return $0 != " "}
        
        assert(scalarStrings.count == 3) //currently the only handled case
        
        guard let x = FloatType(scalarStrings[0]),
            y = FloatType(scalarStrings[1]),
            z = FloatType(scalarStrings[2]) else {
                print("Can't extract vector from line: \(line) with split characters: \(stringyfied)")
                return nil
        }
        
        return Vector3D(x, y, z)
    }
    
    func extractFaceIndicesFrom(line: String) -> [FaceVertexIndices]? {
        let faceVerticeIndicesStrings = line.characters.split(" ").map(String.init).filter {return $0 != " "}
        
        assert(faceVerticeIndicesStrings.count == 3 || faceVerticeIndicesStrings.count == 4)
        
        let firstFaceVertex = faceIndicesFrom(faceVerticeIndicesStrings[0])
        let secondFaceVertex = faceIndicesFrom(faceVerticeIndicesStrings[1])
        let thirdFaceVertex = faceIndicesFrom(faceVerticeIndicesStrings[2])
        var fourthFaceVertex: FaceVertexIndices? = nil
        
        if faceVerticeIndicesStrings.count > 3 {
            fourthFaceVertex = faceIndicesFrom(faceVerticeIndicesStrings[3])
        }
        
        var indices = [firstFaceVertex, secondFaceVertex, thirdFaceVertex]
        
        if let fourthFaceVertex = fourthFaceVertex {
            indices.append(thirdFaceVertex)
            indices.append(fourthFaceVertex)
            indices.append(firstFaceVertex)
        }
        
        return indices
    }
    
    func faceIndicesFrom(stringRepresentation: String) -> FaceVertexIndices {
        let indexValuesAsStrings = stringRepresentation.characters.split("/").map(String.init)
        
        let vertexIndexAsString = indexValuesAsStrings[0]
        let textureIndexAsString = indexValuesAsStrings.count > 1 ? indexValuesAsStrings[1] : ""
        let normalIndexAsString = indexValuesAsStrings.count > 2 ? indexValuesAsStrings[2] : ""

        let numberFormatter = NSNumberFormatter()
        let vertexIndex = numberFormatter.numberFromString(vertexIndexAsString)!.integerValue
        let textureIndex = numberFormatter.numberFromString(textureIndexAsString)?.integerValue
        let normalIndex = numberFormatter.numberFromString(normalIndexAsString)?.integerValue
        
        return FaceVertexIndices(
            vertexIndex: (vertexIndex - 1),
            textureIndex: (textureIndex != nil) ? (textureIndex! - 1) : nil,
            normalIndex: (normalIndex != nil) ? (normalIndex! - 1) : nil
        )
    }
}