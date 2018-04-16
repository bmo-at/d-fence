//
//  GameScene.swift
//  d-fence
//
//  Created by Jan-Robin Aumann on 16.04.18.
//  Copyright © 2018 zom. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        
        addChild(background)
    }
    
}
