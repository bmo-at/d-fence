//
//  2DUtils.swift
//  d-fence
//
//  Created by Hendrik Ulbrich on 25.04.18.
//  Copyright © 2018 zom. All rights reserved.
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

}
