import Foundation

public struct Matrix4x4 {
    
    public let rows = 4
    public let columns = 4
    private var grid: [FloatType]
    
    public init() {
        grid = Array(count: rows*columns, repeatedValue: 0.0)
    }
    
    public init(
        m11: FloatType, m12: FloatType, m13: FloatType, m14: FloatType,
        m21: FloatType, m22: FloatType, m23: FloatType, m24: FloatType,
        m31: FloatType, m32: FloatType, m33: FloatType, m34: FloatType,
        m41: FloatType, m42: FloatType, m43: FloatType, m44: FloatType)
    {
        self.init()
        self[0, 0] = m11; self[0, 1] = m12; self[0, 2] = m13; self[0, 3] = m14;
        self[1, 0] = m21; self[1, 1] = m22; self[1, 2] = m23; self[1, 3] = m24;
        self[2, 0] = m31; self[2, 1] = m32; self[2, 2] = m33; self[2, 3] = m34;
        self[3, 0] = m41; self[3, 1] = m42; self[3, 2] = m43; self[3, 3] = m44;
    }
    
    public static func identityMatrix() -> Matrix4x4 {
        return Matrix4x4(
            m11: 1, m12: 0, m13: 0, m14: 0,
            m21: 0, m22: 1, m23: 0, m24: 0,
            m31: 0, m32: 0, m33: 1, m34: 0,
            m41: 0, m42: 0, m43: 0, m44: 1)
    }
    
    private func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    public subscript(row: Int, column: Int) -> FloatType {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    /**
     * Recursive definition of determinate using expansion by minors.
     *
     * Source: http://paulbourke.net/miscellaneous/determinant/
     */
    public var determinant: FloatType {
        var matrix = Array<Array<FloatType>>(count: grid.count, repeatedValue: Array<FloatType>(count: grid.count, repeatedValue: 0.0))
        
        for row in 0..<rows {
            for column in 0..<columns {
                matrix[row][column] = self[row, column]
            }
        }
        
        return Matrix4x4.recursiveDeterminant(matrix)
    }
    
    private static func recursiveDeterminant(squareMatrix: [[FloatType]]) -> FloatType {
        assert(!squareMatrix.isEmpty)
        
        if (squareMatrix.count == 1) {
            return squareMatrix[0][0]
        } else if (squareMatrix.count == 2) {
            return squareMatrix[0][0] * squareMatrix[1][1] - squareMatrix[1][0] * squareMatrix[0][1]
        } else {
            var determinant: FloatType = 0
            
            for subMatrixId in 0..<squareMatrix.count {
                var subMatrix = Array<Array<FloatType>>(count: squareMatrix.count-1, repeatedValue: Array<FloatType>(count: squareMatrix.count-1, repeatedValue: 0.0))
                
                for i in 1..<squareMatrix.count {
                    var j2 = 0
                    
                    for j in 0..<squareMatrix.count {
                        if (j == subMatrixId) {
                            continue
                        }
                        
                        subMatrix[i-1][j2] = squareMatrix[i][j]
                        j2++
                    }
                }
                
                determinant += pow(-1.0, 1.0+FloatType(subMatrixId)+1.0) * squareMatrix[0][subMatrixId] * recursiveDeterminant(subMatrix)
            }
            
            return determinant
        }
    }
}

public func * (matrix: Matrix4x4, vector: Vector3D) -> Vector3D {
    var resultValues = Array<FloatType>(count: 4, repeatedValue: 0.0)
    
    for row in 0..<4 {
        resultValues[row] = vector.x * matrix[row, 0]
            + vector.y * matrix[row, 1]
            + vector.z * matrix[row, 2]
            + 1 * matrix[row, 3]
    }
    
    var resultVector = Vector3D(resultValues[0], resultValues[1], resultValues[2])
    
    let w = resultValues[3]
    
    if (w != 0) {
        resultVector /= w
    }
    
    return resultVector
}


public func * (var matrix: Matrix4x4, value: FloatType) -> Matrix4x4 {
    matrix *= value
    return matrix
}

public func *= (inout matrix: Matrix4x4, value: FloatType) {
    for row in 0..<matrix.rows {
        for column in 0..<matrix.columns {
            matrix[row, column] *= value
        }
    }
}

public func * (leftHand: Matrix4x4, rightHand: Matrix4x4) -> Matrix4x4 {
    
    var resultMatrix = Matrix4x4()
    
    for row in 0..<4 {
        for column in 0..<4 {
            
            resultMatrix[row, column] = leftHand[0, column] * rightHand[row, 0]
            
            for k in 1..<4 {
                resultMatrix[row, column] += leftHand[k, column] * rightHand[row, k]
            }
        }
    }
    
    return resultMatrix
}

extension Matrix4x4 {
    
    public static func xRotationMatrixFor(var angle: FloatType, inRadians: Bool = false) -> Matrix4x4 {
        if(!inRadians) {
            angle = degreesToRadian(angle)
        }
        
        let sinAng = sin(angle);
        let cosAng = cos(angle);
        
        return Matrix4x4(
            m11: 1, m12:       0, m13:      0, m14: 0,
            m21: 0, m22:  cosAng, m23: sinAng, m24: 0,
            m31: 0, m32: -sinAng, m33: cosAng, m34: 0,
            m41: 0, m42:       0, m43:      0, m44: 1)
    }
    
    public static func yRotationMatrixFor(var angle: FloatType, inRadians: Bool = false) -> Matrix4x4 {
        if(!inRadians) {
            angle = degreesToRadian(angle)
        }
        
        let sinAng = sin(angle);
        let cosAng = cos(angle);
        
        return Matrix4x4(
            m11: cosAng, m12: 0, m13: -sinAng, m14: 0,
            m21:      0, m22: 1, m23:       0, m24: 0,
            m31: sinAng, m32: 0, m33:  cosAng, m34: 0,
            m41:      0, m42: 0, m43:       0, m44: 1)
    }
    
    public static func zRotationMatrixFor(var angle: FloatType, inRadians: Bool = false) -> Matrix4x4 {
        if(!inRadians) {
            angle = degreesToRadian(angle)
        }
        
        let sinAng = sin(angle);
        let cosAng = cos(angle);
        
        return Matrix4x4(
            m11:  cosAng, m12: sinAng, m13: 0, m14: 0,
            m21: -sinAng, m22: cosAng, m23: 0, m24: 0,
            m31:       0, m32:      0, m33: 1, m34: 0,
            m41:       0, m42:      0, m43: 0, m44: 1)
    }
    
    /**
     * @brief Matrix4x4::rotate
     * Source: http://www.songho.ca/opengl/gl_matrix.html
     *
     * @param angle
     * @param axis
     */
    public static func axisRotationMatrix(var angle: FloatType, var axis: Vector3D, inRadians: Bool = false) -> Matrix4x4 {
        if(!inRadians) {
            angle = degreesToRadian(angle)
        }
        
        axis.normalize()
        
        let s = sin(angle);
        let c = cos(angle);
        
        let x = axis.x;
        let y = axis.y;
        let z = axis.z;
        
        let imc = (1.0 - c);
        
        var rotationMatrix = Matrix4x4.identityMatrix()
        
        rotationMatrix[0, 0] = x*x * imc + c;
        rotationMatrix[0, 1] = x*y * imc - z*s;
        rotationMatrix[0, 2] = x*z * imc + y*s;
        
        rotationMatrix[1, 0] = y*x * imc + z*s;
        rotationMatrix[1, 1] = y*y * imc + c;
        rotationMatrix[1, 2] = y*z * imc - x*s;
        
        rotationMatrix[2, 0] = z*x * imc - y*s;
        rotationMatrix[2, 1] = z*y * imc + x*s;
        rotationMatrix[2, 2] = z*z * imc + c;
        
        return rotationMatrix
    }
}

extension Matrix4x4 {
    public static func translationMatrix(location: Vector3D) -> Matrix4x4 {
        return Matrix4x4 (
            m11: 1, m12: 0, m13: 0, m14: location.x,
            m21: 0, m22: 1, m23: 0, m24: location.y,
            m31: 0, m32: 0, m33: 1, m34: location.z,
            m41: 0, m42: 0, m43: 0, m44: 1)
    }
    
    public static func orthonormalMatrix(var u: Vector3D, var d: Vector3D) -> Matrix4x4 {
        let r = d.crossProductWith(u).normalized()
        u = r.crossProductWith(d).normalized()
        d.normalize()
        
        return Matrix4x4(
            m11: r.x, m12: u.x, m13: d.x, m14: 0,
            m21: r.y, m22: u.y, m23: d.y, m24: 0,
            m31: r.z, m32: u.z, m33: d.z, m34: 0,
            m41:   0, m42:   0, m43:   0, m44: 1)
    }
}

extension Matrix4x4 {
    public static func orthographicProjectionMatrix(left: FloatType, right: FloatType, bottom: FloatType, top: FloatType)  -> Matrix4x4 {
    
        return Matrix4x4(
            m11: 2/(right-left), m12:              0, m13: 0, m14: -(right+left)/(right-left),
            m21:              0, m22: 2/(top-bottom), m23: 0, m24: -(top+bottom)/(top-bottom),
            m31:              0, m32:              0, m33: 1, m34:                          0,
            m41:              0, m42:              0, m43: 0, m44:                          1)
    }
    
    public static func perspectiveProjectionMatrix(left: FloatType, right: FloatType, bottom: FloatType, top: FloatType, near: FloatType)  -> Matrix4x4 {
    
        return Matrix4x4(
            m11: 2*near/(right-left), m12:                   0, m13: (right+left)/(right-left), m14:       0,
            m21: 0,                   m22: 2*near/(top-bottom), m23: (top+bottom)/(top-bottom), m24:       0,
            m31: 0,                   m32:                   0, m33:                        -1, m34: -2*near,
            m41: 0,                   m42:                   0, m43:                        -1, m44:       0)
    }
}

extension Matrix4x4 {
    
    public mutating func transpose() {
        for i in 1..<4 {
            for j in 0..<i {
                let tmp = self[i, j]
                self[i, j] = self[j, i]
                self[j, i] = tmp
            }
        }
    }
    
    public func transposed() -> Matrix4x4 {
        var transposedSelf = self
        transposedSelf.transpose()
        return transposedSelf
    }
    
    /**
     * Find the cofactor matrix of a square matrix
     *
     * Source: http://paulbourke.net/miscellaneous/determinant/
     */
    public func coFactorMatrix() -> Matrix4x4 {
        
        var helpMatrix = Array<Array<FloatType>>(count: 3, repeatedValue: Array<FloatType>(count: 3, repeatedValue: 0.0))
        
        var resultMatrix = Matrix4x4()
        
        for row in 0..<rows {
            for column in 0..<columns {
            
                var i1 = 0
                
                for i in 0..<4 {
                    if (i == row) {
                        continue
                    }
                    
                    var j1 = 0
                    
                    for j in 0..<4 {
                        if (j == column) {
                            continue
                        }
                        
                        helpMatrix[i1][j1] = self[i, j]
                        j1++
                    }
                    i1++
                }
                
                let helpMatrixDeterminant = Matrix4x4.recursiveDeterminant(helpMatrix)
                
                resultMatrix[row, column] = pow(-1.0, FloatType(row+column)+2.0) * helpMatrixDeterminant
            }
        }
        
        return resultMatrix
    }
    
    public func inverted() -> Matrix4x4? {
        let determinant = self.determinant
        if (determinant == 0) {
            return nil
        } else {
            var adjointMatrix = coFactorMatrix()
            adjointMatrix.transpose()
            adjointMatrix *= 1/determinant
            return adjointMatrix
        }
    }
    
    public func normalMatrix() -> Matrix4x4? {
        return inverted()?.transposed()
    }
}