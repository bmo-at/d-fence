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
        
        let startLabel = SKLabelNode(fontNamed: "October Crow")
        startLabel.text = "START"
        startLabel.fontColor = SKColor.white
        startLabel.fontSize = 100
        startLabel.zPosition = 150
        startLabel.position = CGPoint(x: size.width/2, y: (size.height - 100) * 0.7)
       
        let scoreLabel = SKLabelNode(fontNamed: "October Crow")
        scoreLabel.text = "SCORE"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 100
        scoreLabel.zPosition = 150
        scoreLabel.position = CGPoint(x: size.width/2, y: (size.height - 100) * 0.5)
        
        let aboutLabel = SKLabelNode(fontNamed: "October Crow")
        aboutLabel.text = "ABOUT"
        aboutLabel.fontColor = SKColor.white
        aboutLabel.fontSize = 100
        aboutLabel.zPosition = 150
        aboutLabel.position = CGPoint(x: size.width/2, y: (size.height - 100) * 0.3)
        
        addChild(background)
        addChild(startLabel)
        addChild(scoreLabel)
        addChild(aboutLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO react to click event
    }
    
}
