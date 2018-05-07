//
//  GameScene.swift
//  d-fence
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "menu-background")
        
        let ratio = background.size.width / background.size.height
        let screenRatio = self.size.width / self.size.height
        
        let backgroundSize: CGSize!
        if (ratio < screenRatio) { // cut the top height
            backgroundSize = CGSize(width: self.size.width, height: self.size.width / ratio)
        } else { // cut the right side
            backgroundSize = CGSize(width: self.size.height * ratio, height: self.size.height)
        }
        
        background.scale(to: backgroundSize)
        
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = 0
        
        let startLabel = generateMenuItem(text: NSLocalizedString("START", comment: ""), name: "start", vpos: 0.7)
        let scoreLabel = generateMenuItem(text: NSLocalizedString("SCORES", comment: ""), name: "score", vpos: 0.5)
        let aboutLabel = generateMenuItem(text: NSLocalizedString("ABOUT", comment: ""), name: "about", vpos: 0.3)
        
        addChild(background)
        addChild(startLabel)
        addChild(scoreLabel)
        addChild(aboutLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            Sound.play(file: "slingshotfires.wav")
            if name == "start" {
                transitScene(to: "GameScene")
            } else if name == "about" {
                transitScene(to: "AboutScene")
            } else if name == "score" {
                transitScene(to: "ScoreScene")
            }
        }
    }
    
    func transitScene(to: String) {
        let scene: SKScene
        
        if to == "GameScene" {
            scene = GameScene(size: self.size)
        } else if to == "ScoreScene" {
            scene = ScoreScene(size: self.size)
        } else { // About
            scene = AboutScene(size: self.size)
        }
        
        view?.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    func generateMenuItem(text: String, name: String, vpos: Float) -> SKLabelNode {
        let label = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 7);
        label.borderColor = UIColor.black
        label.borderWidth = label.fontSize / 4.5
        label.outlinedText = text
        label.name = name
        label.fontColor = UIColor.white
        label.zPosition = 150
        label.position = CGPoint(x: size.width / 4, y: CGFloat(Float(size.height - label.fontSize) * vpos))
        
        return label
    }
    
}
