//
//  Scout.swift
//  d-fence
//

import SpriteKit

class Scout {
    
    // MARK: The scout module 🙋‍♂️
    
    let node: SKSpriteNode = SKSpriteNode(imageNamed: "scout")
    
    var upgrade: UpgradeInterface.Upgrade = UpgradeInterface.Upgrade.STONE
    var damage: CGFloat = GameConstants.stoneDamage
    var fireCooldown: TimeInterval = GameConstants.stoneCooldown
    var currentHealthPoints: CGFloat = GameConstants.treehouseHealthPoints
    var maxHealthPoints: CGFloat = GameConstants.treehouseHealthPoints
    var bulletVelocity: CGFloat = GameConstants.stoneVelocity
    
    // Rotate the scout element (currently not necessary as we are rendering a treehouse (which should not rotate...))
    func updateRotation(touchPoint: CGPoint) {
        let a = CGPoint(x: 1, y: 0)
        let t = CGPoint(x: touchPoint.x - node.position.x, y: touchPoint.y - node.position.y)
        node.zRotation = Utils.vectorAngular(vectorA: a, vectorB: t)
    }
    
    // Shots should move away from the scoutj
    func calculateDirectionOfShot(size: CGSize, touchPoint: CGPoint) -> CGPoint {
        let difference = CGPoint(x: touchPoint.x - node.position.x, y: touchPoint.y - node.position.y)
        return Utils.vectorScale(vector: Utils.vectorNorm(vector: difference), scale: bulletVelocity * size.height)
    }
    
    init(size: CGSize) {
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        node.zPosition = 10
        node.scale(to: CGSize(width: size.height / 4, height: size.height / 4))
        node.name = "scout"
    }
}
