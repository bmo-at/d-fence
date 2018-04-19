//
//  GameScene.swift
//  d-fence
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let touchDebug = true
    let scout : SKSpriteNode = SKSpriteNode(imageNamed: "scout")
    let background : SKSpriteNode = SKSpriteNode(imageNamed: "background")
    var shots : [SKSpriteNode] = []
    
    var bulletMovePointsPerSecond: CGFloat = 480.0
    var velocity = CGPoint.zero
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var isMoving = false
    
    override func didMove(to view: SKView) {
        // replace with init background when assets are ready
        // initBackground()
        backgroundColor = UIColor.green
        
        initScout()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0 }
        lastUpdateTime = currentTime
        
        print("\(dt*1000) milliseconds since last update")
        
        
        for shot in shots {
            shot.position = CGPoint(x: shot.position.x + 8, y: shot.position.y)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            print(name)
            if name == "scout" {
                touchDebug("User clicked scout")
                isMoving = true
            }
        } else {
            touchDebug("User clicked anything else...")
            updateScoutRotation(tPoint: positionInScene)
            initShot(tPoint: positionInScene)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            touchDebug(name)
            if name == "scout" {
                touchDebug("User is moving finger over scout")
            }
        } else {
            touchDebug("User is moving finger over anything else")
            updateScoutRotation(tPoint: positionInScene)
        }
    }
    
    func touchDebug(_ output: String) {
        if touchDebug {
            print(output)
        }
    }
    
    func vectorDot(a: CGPoint, b: CGPoint) -> CGFloat {
        return a.x * b.x + a.y * b.y
    }
    
    func vectorNorm(a: CGPoint) -> CGFloat {
        return sqrt(vectorDot(a: a, b: a))
    }
    
    func updateScoutRotation(tPoint: CGPoint) {
        let a = CGPoint(x: 1, y: 0)
        let t = CGPoint(x: tPoint.x - scout.position.x, y: tPoint.y - scout.position.y)
        
        let phi = acos(vectorDot(a: a, b: t) / (vectorNorm(a: a) * vectorNorm(a: t)))
        
        // as scalar dot only returns angulars smaller 180 degrees, negate on big angulars
        scout.zRotation = t.y > 0 ? phi : -phi;
    }
    
    func initBackground() {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        
        addChild(background)
    }
    
    func initShot(tPoint: CGPoint) {
        let newShot = SKSpriteNode(imageNamed: "bullet")
        newShot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newShot.position = scout.position
        newShot.zPosition = 20
        
        shots.append(newShot)

        addChild(newShot)
    }
    
    func initScout() {
        scout.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scout.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scout.zPosition = 10
        scout.name = "scout"
        
        addChild(scout)
    }
    
    
    
}
