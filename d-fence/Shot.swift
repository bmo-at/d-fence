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
    var direction: CGPoint
    
    required init(size: CGSize, scoutPosition: CGPoint, direction: CGPoint) {
        self.node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.node.position = scoutPosition
        self.node.zPosition = 20
        self.node.scale(to: CGSize(width: size.height / 70, height: size.height / 70))
        
        self.direction = direction
    }
}
