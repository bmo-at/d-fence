//
//  GameScene.swift
//  d-fence
//
//  Created by Jan-Robin Aumann on 16.04.18.
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
        startLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        
        addChild(background)
        addChild(startLabel)
    }
    
}
