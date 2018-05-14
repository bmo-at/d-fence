//
//  AboutScene.swift
//  d-fence
//

import SpriteKit

class ScoreScene: SKScene {
    
    // MARK: Score Scene Component
    
    let defaults = UserDefaults.standard
    //load initialy the scene
    override func didMove(to view: SKView) {
        //init background and set image to it
        backgroundColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
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
        //set title label settings
        let title = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 5);
        title.borderColor = UIColor.black
        title.borderWidth = title.fontSize / 4.5
        title.outlinedText = NSLocalizedString("HIGHSCORES", comment: "")
        title.name = "title"
        title.fontColor = UIColor.white
        title.zPosition = 150
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        //set back label settings
        let back = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 10);
        back.borderColor = UIColor.black
        back.borderWidth = back.fontSize / 4.5
        back.outlinedText = NSLocalizedString("BACK", comment: "")
        back.name = "back"
        back.fontColor = UIColor.white
        back.zPosition = 150
        back.position = CGPoint(x: back.frame.size.width / 2 * 1.2, y: back.frame.size.height / 2)
      
        // Initialize all labels with the scores (labels are in horizontal center)
        // Getting values from userdefaults with keys
        for i in 0...9 {
            var wave = -1
            var score_reached = -1
            if defaults.value(forKey: "wave\(i)") != nil {
                wave = defaults.value(forKey: "wave\(i)") as! Int
            }
            if defaults.value(forKey: "score\(i)") != nil {
                score_reached = defaults.value(forKey: "score\(i)") as! Int
            }
            let score = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 15);
            score.borderColor = UIColor.black
            score.borderWidth = score.fontSize / 4.5
            if wave != -1 {
                score.outlinedText = "\(i+1). " + NSLocalizedString("WAVE", comment: "") + " \(wave), \(score_reached) " + NSLocalizedString("SCORE", comment: "")
            }
            score.name = "score\(i)"
            score.fontColor = UIColor.white
            score.zPosition = 150
            score.position = CGPoint(x: size.width / 2, y: (size.height * 0.7) - (CGFloat(i) * score.frame.height * 1.5))
            
            addChild(score)
        }
        
        addChild(title)
        addChild(back)
        addChild(background)
    }

    // Override touchesEnded
    // Play click sound on label click
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        //when back label touched, go back to main menu with scene transition
        if let name = touchedNode.name {
            if name == "back" {
                Sound.play(file: "slingshotfires.wav")
                view?.presentScene(MainMenuScene(size: self.size), transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
