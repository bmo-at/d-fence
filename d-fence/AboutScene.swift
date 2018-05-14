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
        let title = generateMenuItem(localizedText: "ABOUT", name: "title", fontSize: size.height / 5, vpos: 0.85, hpos: 0.5)
        let back = generateMenuItem(localizedText: "BACK", name: "back", fontSize: size.height / 10, vpos: 0.05, hpos: 0.1)
        let gameInfo = generateMenuItem(localizedText: "GAME_CREDIT", name: "gameInfo", fontSize: size.height / 10, vpos: 0.6, hpos: 0.5)
        let authorInfo1 = generateMenuItem(localizedText: "AUTHOR1_CREDIT", name: "authorInfo", fontSize:size.height / 10, vpos: 0.45, hpos: 0.5);
        let authorInfo2 = generateMenuItem(localizedText: "AUTHOR2_CREDIT", name: "authorInfo", fontSize:size.height / 10, vpos: 0.35, hpos: 0.5);
        let authorInfo3 = generateMenuItem(localizedText: "AUTHOR3_CREDIT", name: "authorInfo", fontSize:size.height / 10, vpos: 0.25, hpos: 0.5);
        let authorInfo4 = generateMenuItem(localizedText: "MUSIC_CREDIT", name: "authorInfo", fontSize:size.height / 15, vpos: 0.15, hpos: 0.5);

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
    
    // Generic function for rendering about labels
    func generateMenuItem(localizedText: String, name: String, fontSize: CGFloat, vpos: CGFloat, hpos: CGFloat) -> SKLabelNode {
        let label = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: fontSize);
        label.borderColor = UIColor.black
        label.borderWidth = label.fontSize / 4.5
        label.outlinedText = NSLocalizedString(localizedText, comment: "")
        label.name = name
        label.fontColor = UIColor.white
        label.zPosition = 150
        label.position = CGPoint(x: size.width * hpos, y: (size.height - label.frame.height / 2) * vpos)
        
        return label
    }
    
}
