//
//  AboutScene.swift
//  d-fence
//

import SpriteKit

class AboutScene: SKScene {
    
    override func didMove(to view: SKView) {
        let title = MKOutlinedLabelNode(fontNamed: "8BITWONDERNominal", fontSize: size.height / 10);
        title.borderColor = UIColor.black
        title.borderWidth = title.fontSize / 4.5
        title.outlinedText = "ABOUT"
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
        
        let gameInfo = MKOutlinedLabelNode(fontNamed: "8BITWONDERNominal", fontSize: size.height / 25);
        gameInfo.borderColor = UIColor.black
        gameInfo.borderWidth = gameInfo.fontSize / 4.5
        gameInfo.outlinedText = "d-fence 2018"
        gameInfo.name = "gameInfo"
        gameInfo.fontColor = UIColor.white
        gameInfo.zPosition = 150
        gameInfo.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let authorInfo = MKOutlinedLabelNode(fontNamed: "8BITWONDERNominal", fontSize: size.height / 25);
        authorInfo.borderColor = UIColor.black
        authorInfo.borderWidth = authorInfo.fontSize / 4.5
        authorInfo.outlinedText = "J-R.Aumann, O.Kardos, H.Ulbrich"
        authorInfo.name = "authorInfo"
        authorInfo.fontColor = UIColor.white
        authorInfo.zPosition = 150
        authorInfo.position = CGPoint(x: size.width / 2, y: size.height / 3)
        
        addChild(authorInfo)
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
                view?.presentScene(MainMenuScene(size: self.size), transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
