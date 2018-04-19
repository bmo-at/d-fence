//
//  GameScene.swift
//  d-fence
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let scout : SKSpriteNode = SKSpriteNode(imageNamed: "scout")
    let background : SKSpriteNode = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.green // replace with init background when assets are ready
        
        renderScout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            print(name)
            if name == "scout" {
                print("User clicked scout")
            }
        } else {
            print("User clicked anything else...")
            updateScoutRotation(tPoint: positionInScene)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            print (name)
            if name == "scout" {
                print("User is holding finger over scout")
            }
        } else {
            print("User is holding finger over anything else")
            updateScoutRotation(tPoint: positionInScene)
        }
    }
    
    func vector_dot(a: CGPoint, b: CGPoint) -> CGFloat {
        return a.x * b.x + a.y * b.y
    }
    
    func vector_norm(a: CGPoint) -> CGFloat {
        return sqrt(vector_dot(a: a, b: a))
    }
    
    func updateScoutRotation(tPoint: CGPoint) {
        let a = CGPoint(x: 1, y: 0)
        let t = CGPoint(x: tPoint.x - scout.position.x, y: tPoint.y - scout.position.y)
        
        let phi = acos(vector_dot(a: a, b: t) / (vector_norm(a: a) * vector_norm(a: t)))
        
        scout.zRotation = t.y > 0 ? phi : -phi;
    }
    
    func initBackground() {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        
        addChild(background)
    }
    
    func renderScout() {
        scout.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scout.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scout.zPosition = 10
        scout.name = "scout"
        
        addChild(scout)
    }
    
}
