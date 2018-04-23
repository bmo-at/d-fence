//
//  GameScene.swift
//  d-fence
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let touchDebug = false
    let despawnBound:CGFloat = 32 // points
    
    let scout: SKSpriteNode = SKSpriteNode(imageNamed: "scout")
    let background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    
    var shots = [SKSpriteNode: CGPoint]()
    var touchPosition: CGPoint!
    var fireTimestamp: Date?
    var fireCooldown:TimeInterval = 1.0 // seconds
    var bulletVelocity: CGFloat = 480 // points / sec
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
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
            dt = 0
        }
        lastUpdateTime = currentTime
        
        updateShots()
    }
    
    func updateShots() {
        for (shot, direction) in shots {
            shot.position = CGPoint(x: shot.position.x + (direction.x * CGFloat(dt)), y: shot.position.y + (direction.y * CGFloat(dt)))
            
            // Remove all nodes which are out of the screen
            if (shot.position.x < -despawnBound || shot.position.x > size.width + despawnBound || shot.position.y < -despawnBound || shot.position.y > size.height + despawnBound) {
                shot.removeFromParent()
                shots.removeValue(forKey: shot)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        
        if let name = touchedNode.name {
            touchDebug(name)
            if name == "scout" {
                touchDebug("User clicked scout")
            }
        } else {
            touchDebug("User clicked anything else...")
            updateScoutRotation(touchPoint: touchPosition)
            
            tryToFire()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        
        if let name = touchedNode.name {
            touchDebug(name)
            if name == "scout" {
                touchDebug("User is moving finger over scout")
            }
        } else {
            touchDebug("User is moving finger over anything else")
            updateScoutRotation(touchPoint: touchPosition)
            
            tryToFire()
        }
    }
    
    func touchDebug(_ output: String) {
        if touchDebug {
            print(output)
        }
    }
    
    func vectorDot(vectorA: CGPoint, vectorB: CGPoint) -> CGFloat {
        return vectorA.x * vectorB.x + vectorA.y * vectorB.y
    }
    
    func vectorAbs(vector: CGPoint) -> CGFloat {
        return sqrt(vectorDot(vectorA: vector, vectorB: vector))
    }
    
    func vectorNorm(vector: CGPoint) -> CGPoint {
        let abs = vectorAbs(vector: vector)
        return CGPoint(x: vector.x / abs, y: vector.y / abs)
    }
    
    func vectorScale(vector: CGPoint, scale: CGFloat) -> CGPoint {
        return CGPoint(x: vector.x * scale, y: vector.y * scale)
    }
    
    func calculateDirectionOfShot(touchPoint: CGPoint) -> CGPoint {
        let difference = CGPoint(x: touchPoint.x - scout.position.x, y: touchPoint.y - scout.position.y)
        return vectorScale(vector: vectorNorm(vector: difference), scale: bulletVelocity)
    }
    
    func tryToFire() {
        let sinceLastFiringAttempt = Date().timeIntervalSince(fireTimestamp ?? Date(timeIntervalSince1970: 0));
        
        if (sinceLastFiringAttempt > fireCooldown) {
            fireTimestamp = Date()
            initShot(touchPoint: touchPosition)
        }
    }
    
    func initShot(touchPoint: CGPoint) {
        let newShot = SKSpriteNode(imageNamed: "bullet")
        newShot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newShot.position = scout.position
        newShot.zPosition = 20
        
        shots[newShot] = calculateDirectionOfShot(touchPoint: touchPoint)
        
        addChild(newShot)
    }
    
    func initScout() {
        scout.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scout.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scout.zPosition = 10
        scout.name = "scout"
        
        addChild(scout)
    }
    
    func updateScoutRotation(touchPoint: CGPoint) {
        let a = CGPoint(x: 1, y: 0)
        let t = CGPoint(x: touchPoint.x - scout.position.x, y: touchPoint.y - scout.position.y)
        
        let phi = acos(vectorDot(vectorA: a, vectorB: t) / (vectorAbs(vector: a) * vectorAbs(vector: t)))
        
        // as scalar dot only returns angulars smaller 180 degrees, negate on big angulars
        scout.zRotation = t.y > 0 ? phi : -phi;
    }
    
    func initBackground() {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        
        addChild(background)
    }
    
}
