//
//  Clipping.swift
//  RenderingBase
//
//  Created by Rainer Schlönvoigt on 23/02/16.
//  Copyright © 2016 Rainer Schlönvoigt. All rights reserved.
//

import Foundation

typealias VertexIsInside = (vertex: AttributedVector) -> Bool
typealias Intersect = (vertex1: AttributedVector, vertex2: AttributedVector) -> AttributedVector

public class Clipper {
    
    public func clipTriangle(triangle: [AttributedVector], perTriangleFunction: ([AttributedVector]) -> Void) {
        assert(triangle.count == 3, "wrong amount of vertices in a triangle: [\(triangle.count)]")
        
        let clippedPolygon = clipLeft( clipRight( clipBottom( clipTop(triangle))))
        assert(clippedPolygon.count == 0 || clippedPolygon.count >= 3)
        
        if (clippedPolygon.isEmpty) {
            return
        }
        
        for vertexIndex in 2..<clippedPolygon.count {
            perTriangleFunction(
                [clippedPolygon[0],
                    clippedPolygon[vertexIndex-1],
                    clippedPolygon[vertexIndex]] )
        }
    }
    
    private func intersectAtX(vertex1: AttributedVector, vertex2: AttributedVector, x: FloatType) -> AttributedVector {
        let alpha = BoundingBoxRange(min: vertex1.normalizedDeviceCoordinate!.x, max: vertex2.normalizedDeviceCoordinate!.x)!.alphaForValue(x)
        assert(alpha >= 0 && alpha <= 1)
        
        return AttributedVector.linearInterpolate(vertex1, second: vertex2, alpha: alpha)
    }
    
    private func intersectAtY(vertex1: AttributedVector, vertex2: AttributedVector, y: FloatType) -> AttributedVector {
        let alpha = BoundingBoxRange(min: vertex1.normalizedDeviceCoordinate!.y, max: vertex2.normalizedDeviceCoordinate!.y)!.alphaForValue(y)
        assert(alpha >= 0 && alpha <= 1)
        
        return AttributedVector.linearInterpolate(vertex1, second: vertex2, alpha: alpha)
    }
    
    private func genericClip(polygon: [AttributedVector], vertexIsInside: VertexIsInside, intersect: Intersect) -> [AttributedVector] {
        let vertexIsInsideTable = polygon.map(vertexIsInside)
        
        var polygonVertices = [AttributedVector]()
        
        for vertexIndex in 0..<polygon.count {
            
            let previousIndex = (vertexIndex + vertexIsInsideTable.count - 1) % vertexIsInsideTable.count
            if vertexIsInsideTable[vertexIndex] != vertexIsInsideTable[previousIndex] {
                polygonVertices.append( intersect(vertex1: polygon[vertexIndex], vertex2: polygon[previousIndex]) )
            }
            
            if vertexIsInsideTable[vertexIndex] {
                polygonVertices.append(polygon[vertexIndex])
            }
        }
        
        return polygonVertices
    }
    
    private func clipLeft(polygon: [AttributedVector]) -> [AttributedVector] {
        return genericClip(polygon,
            vertexIsInside: { return $0.normalizedDeviceCoordinate!.x >= -1.0 },
            intersect: {self.intersectAtX($0, vertex2: $1, x: -1.0)})
    }
    
    private func clipRight(polygon: [AttributedVector]) -> [AttributedVector] {
        return genericClip(polygon,
            vertexIsInside: { return $0.normalizedDeviceCoordinate!.x <= 1.0 },
            intersect: {self.intersectAtX($0, vertex2: $1, x: 1.0)})
    }
    
    private func clipBottom(polygon: [AttributedVector]) -> [AttributedVector] {
        return genericClip(polygon,
            vertexIsInside: { return $0.normalizedDeviceCoordinate!.y >= -1.0 },
            intersect: {self.intersectAtY($0, vertex2: $1, y: -1.0)})
    }
    
    private func clipTop(polygon: [AttributedVector]) -> [AttributedVector] {
        return genericClip(polygon,
            vertexIsInside: { return $0.normalizedDeviceCoordinate!.y <= 1.0 },
            intersect: {self.intersectAtY($0, vertex2: $1, y: 1.0)})
    }
}