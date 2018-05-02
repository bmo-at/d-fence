//
//  HighscoreScene.swift
//  d-fence
//
//  Created by Oliver Kardos on 01.05.18.
//  Copyright © 2018 zom. All rights reserved.
//

import SpriteKit
import GameplayKit

class HighscoreScene: SKScene {
    
    let defaults = UserDefaults.standard
    
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
        
        for i in 0...4 {
            var name = "leer"
            var score = "leer"
            if defaults.value(forKey: "name\(i)") != nil {
                name = defaults.value(forKey: "name\(i)") as! String
            }
            if defaults.value(forKey: "score\(i)") != nil {
                score = defaults.value(forKey: "score\(i)") as! String
            }
            let nameLabel = generateLabel(text: name, name: "name\(i)", vpos: Float(0.2) * Float(i), pos: 0.3)
            let scoreLabel = generateLabel(text: score, name: "score\(i)", vpos: Float(0.2) * Float(i), pos: 0.7)
            addChild(nameLabel)
            addChild(scoreLabel)
        }
        addChild(background)
        let back = generateLabel(text: "BACK", name: "back", vpos: 0, pos: 0.9)
        addChild(back)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "back" {
                let scene = MainMenuScene(size: self.size)
                let reveal = SKTransition.fade(withDuration: 0.5)
                view?.presentScene(scene, transition: reveal)
            }
        }
    }
    func generateLabel(text: String, name: String, vpos: Float, pos: Float) -> SKLabelNode {
        let label = MKOutlinedLabelNode(fontNamed: "8BITWONDERNominal", fontSize: self.size.height / 15);
        label.borderColor = UIColor.black
        label.borderWidth = label.fontSize / 4.5
        label.outlinedText = text
        label.name = name
        label.fontColor = UIColor.white
        label.zPosition = 150
        label.position = CGPoint(x: CGFloat(Float(size.width) * pos), y: CGFloat(Float(size.height - label.fontSize) * vpos) + 40)
        print(CGFloat(Float(size.height - label.fontSize) * vpos))
        return label
    }
    
}

