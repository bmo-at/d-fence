//
//  Utils.swift
//  d-fence
//

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

    static func vectorsAngular(vectorA: CGPoint, vectorB: CGPoint) -> CGFloat {
        let phi = acos(Utils.vectorDot(vectorA: vectorA, vectorB: vectorB) / (Utils.vectorAbs(vector: vectorA) * Utils.vectorAbs(vector: vectorB)))
        
        // as scalar dot only returns angulars smaller 180 degrees, negate on big angulars
        return vectorB.y > 0 ? phi : -phi;
    }
    
}
