//
//  Utils.swift
//  d-fence
//
// This class is a utility class which provides linear 2d calculation functions. These are core functions but they arent available as easy for the CG objects as we want so we write our own.

import SpriteKit

class Utils {

    static func vectorDot(vectorA: CGPoint, vectorB: CGPoint) -> CGFloat {
        return vectorA.x * vectorB.x + vectorA.y * vectorB.y
    }
    
    static func vectorAbs(vector: CGPoint) -> CGFloat {
        return sqrt(vectorDot(vectorA: vector, vectorB: vector))
    }
    
    static func vectorNorm(vector: CGPoint) -> CGPoint {
        let abs = vectorAbs(vector: vector)
        return CGPoint(x: vector.x / abs, y: vector.y / abs)
    }
    
    static func vectorScale(vector: CGPoint, scale: CGFloat) -> CGPoint {
        return CGPoint(x: vector.x * scale, y: vector.y * scale)
    }

    static func vectorAngular(vectorA: CGPoint, vectorB: CGPoint) -> CGFloat {
        let phi = acos(Utils.vectorDot(vectorA: vectorA, vectorB: vectorB) / (Utils.vectorAbs(vector: vectorA) * Utils.vectorAbs(vector: vectorB)))
        
        // as scalar dot only returns angulars smaller 180 degrees, negate on big angulars
        return vectorB.y > 0 ? phi : -phi;
    }
    
    static func vectorDistance(vectorA: CGPoint, vectorB: CGPoint) -> CGFloat {
        return vectorAbs(vector: CGPoint(x: vectorA.x - vectorB.x, y: vectorA.y - vectorB.y))
    }
    
}
