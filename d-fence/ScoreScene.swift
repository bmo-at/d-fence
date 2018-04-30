//
//  AboutScene.swift
//  d-fence
//

import SpriteKit

class ScoreScene: SKScene {
    
    override func didMove(to view: SKView) {
        let title = MKOutlinedLabelNode(fontNamed: "8BITWONDERNominal", fontSize: size.height / 10);
        title.borderColor = UIColor.black
        title.borderWidth = title.fontSize / 4.5
        title.outlinedText = "HIGHSCORES"
        title.name = "title"
        title.fontColor = UIColor.white
        title.zPosition = 150
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
    
        let back = MKOutlinedLabelNode(fontNamed: "8BITWONDERNominal", fontSize: size.height / 15);
        back.borderColor = UIColor.black
        back.borderWidth = back.fontSize / 4.5
        back.outlinedText = "BACK"
        back.name = "back"
        back.fontColor = UIColor.white
        back.zPosition = 150
        back.position = CGPoint(x: back.frame.size.width / 2 * 1.2, y: back.frame.size.height / 2)
    
        // TODO: Load scores from drive
        
        let scores: [String] = ["Wave 1, 34 234 Points", "Wave 2, 34 234 Points", "Wave 3, 34 234 Points", "Wave 4, 34 234 Points", "Wave 5, 34 234 Points", "Wave 6, 34 234 Points", "Wave 7, 34 234 Points", "Wave 8, 34 234 Points", "Wave 9, 34 234 Points", "Wave 10, 34 234 Points"]
        
        for i in 0...9 {
            let score = MKOutlinedLabelNode(fontNamed: "8BITWONDERNominal", fontSize: size.height / 25);
            score.borderColor = UIColor.black
            score.borderWidth = score.fontSize / 4.5
            score.outlinedText = "\(i+1). \(scores[i])"
            score.name = "score\(i)"
            score.fontColor = UIColor.white
            score.zPosition = 150
            score.position = CGPoint(x: size.width / 2, y: (size.height * 0.7) - (CGFloat(i) * score.frame.height * 1.5))
            
            addChild(score)
        }
        
        addChild(title)
        addChild(back)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "back" {
                view?.presentScene(MainMenuScene(size: self.size), transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
