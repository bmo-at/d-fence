//
//  Shot.swift
//  d-fence
//

import SpriteKit

class Shot: Hashable {
    
    static func == (lhs: Shot, rhs: Shot) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return node.hashValue
    }
    
    let node: SKSpriteNode = SKSpriteNode(imageNamed: "bullet")
    
    required init(size: CGSize, scoutPosition: CGPoint) {
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = scoutPosition
        node.zPosition = 20
        node.scale(to: CGSize(width: size.height / 40, height: size.height / 40))
    }
}
