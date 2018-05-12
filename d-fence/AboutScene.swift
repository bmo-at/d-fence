//
//  AboutScene.swift
//  d-fence
//

import SpriteKit

class AboutScene: SKScene {
    
    // MARK: About Scene Component
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        
        // Generate labels for every author and the app name
        
        let title = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 5);
        title.borderColor = UIColor.black
        title.borderWidth = title.fontSize / 4.5
        title.outlinedText = NSLocalizedString("ABOUT", comment: "")
        title.name = "title"
        title.fontColor = UIColor.white
        title.zPosition = 150
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        
        let back = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 10);
        back.borderColor = UIColor.black
        back.borderWidth = back.fontSize / 4.5
        back.outlinedText = NSLocalizedString("BACK", comment: "")
        back.name = "back"
        back.fontColor = UIColor.white
        back.zPosition = 150
        back.position = CGPoint(x: back.frame.size.width / 2 * 1.2, y: back.frame.size.height / 2)
        
        let gameInfo = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 10);
        gameInfo.borderColor = UIColor.black
        gameInfo.borderWidth = gameInfo.fontSize / 4.5
        gameInfo.outlinedText = "d-fence © 2018"
        gameInfo.name = "gameInfo"
        gameInfo.fontColor = UIColor.white
        gameInfo.zPosition = 150
        gameInfo.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let authorInfo1 = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 10);
        authorInfo1.borderColor = UIColor.black
        authorInfo1.borderWidth = authorInfo1.fontSize / 4.5
        authorInfo1.outlinedText = "Jan-Robin Aumann"
        authorInfo1.name = "authorInfo"
        authorInfo1.fontColor = UIColor.white
        authorInfo1.zPosition = 150
        authorInfo1.position = CGPoint(x: size.width / 2, y: size.height / 3)
        
        let authorInfo2 = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 10);
        authorInfo2.borderColor = UIColor.black
        authorInfo2.borderWidth = authorInfo2.fontSize / 4.5
        authorInfo2.outlinedText = "Oliver Kardos"
        authorInfo2.name = "authorInfo"
        authorInfo2.fontColor = UIColor.white
        authorInfo2.zPosition = 150
        authorInfo2.position = CGPoint(x: size.width / 2, y: size.height / 3 - authorInfo2.frame.height * 1.5)
        
        let authorInfo3 = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 10);
        authorInfo3.borderColor = UIColor.black
        authorInfo3.borderWidth = authorInfo3.fontSize / 4.5
        authorInfo3.outlinedText = "Hendrik Ulbrich"
        authorInfo3.name = "authorInfo"
        authorInfo3.fontColor = UIColor.white
        authorInfo3.zPosition = 150
        authorInfo3.position = CGPoint(x: size.width / 2, y: size.height / 3 - authorInfo2.frame.height * 3)
        
        let authorInfo4 = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 17);
        authorInfo4.borderColor = UIColor.black
        authorInfo4.borderWidth = authorInfo4.fontSize / 4.5
        authorInfo4.outlinedText = "Music by Malte Bartels"
        authorInfo4.name = "authorInfo"
        authorInfo4.fontColor = UIColor.white
        authorInfo4.zPosition = 150
        authorInfo4.position = CGPoint(x: size.width / 2, y: size.height / 3 - authorInfo2.frame.height * 4.5)
        
        addChild(authorInfo1)
        addChild(authorInfo2)
        addChild(authorInfo3)
        addChild(authorInfo4)
        addChild(gameInfo)
        addChild(title)
        addChild(back)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "back" {
                Sound.play(file: "slingshotfires.wav")
                view?.presentScene(MainMenuScene(size: self.size), transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
