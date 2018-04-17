//
//  GameScene.swift
//  d-fence
//
//  Created by Hendrik Ulbrich on 16.04.18.
//  Copyright © 2018 zom. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "menu-background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        
        let startLabel = generateMenuItem(text: "START", name: "start", vpos: 0.7)
        let scoreLabel = generateMenuItem(text: "SCORES", name: "score", vpos: 0.5)
        let aboutLabel = generateMenuItem(text: "ABOUT", name: "about", vpos: 0.3)
        
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
            if name == "start" {
                print("START")
            } else if name == "score" {
                print("SCORE")
            } else if name == "about" {
                print("ABOUT");
            }
        }
    }
    
    func generateMenuItem(text: String, name: String, vpos: Float) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "October Crow");
        
        label.text = text
        label.name = name
        label.fontColor = SKColor.white
        label.fontSize = 100
        label.zPosition = 150
        label.position = CGPoint(x: size.width / 2, y: CGFloat(Float(size.height - 100) * vpos))
        
        return label
    }
    
}
