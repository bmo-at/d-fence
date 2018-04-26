//
//  Scout.swift
//  d-fence
//

import SpriteKit

class Scout {
    
    var damage: CGFloat = 10
    var currentHealthPoints: CGFloat = 100
    var maxHealthPoints: CGFloat = 100
    let node: SKSpriteNode = SKSpriteNode(imageNamed: "scout")
    
    var bulletVelocity: CGFloat = 0.5 // %
    
    func updateRotation(touchPoint: CGPoint) {
        let a = CGPoint(x: 1, y: 0)
        let t = CGPoint(x: touchPoint.x - node.position.x, y: touchPoint.y - node.position.y)
        node.zRotation = Utils.vectorsAngular(vectorA: a, vectorB: t)
    }
    
    func calculateDirectionOfShot(size: CGSize, touchPoint: CGPoint) -> CGPoint {
        let difference = CGPoint(x: touchPoint.x - node.position.x, y: touchPoint.y - node.position.y)
        return Utils.vectorScale(vector: Utils.vectorNorm(vector: difference), scale: bulletVelocity * size.height)
    }
    
    init(size: CGSize) {
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        node.zPosition = 10
        node.scale(to: CGSize(width: size.height / 10, height: size.height / 10)) // 10% vertical
        node.name = "scout"
    }
}
