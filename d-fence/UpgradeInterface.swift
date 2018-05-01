//
//  UpgradeInterface.swift
//  d-fence
//

import SpriteKit

class UpgradeInterface {
    static let backgroundColor: SKColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    
    let node: SKSpriteNode
    let backdrop: SKShapeNode
    let upgradeMenuBackground: SKShapeNode
    let nextWaveBackground: SKShapeNode
    let statsBackground: SKShapeNode
    let titleLabel: SKOutlinedLabelNode
    let statsTitleLabel: SKOutlinedLabelNode
    let nextWaveLabel: SKOutlinedLabelNode
    
    required init(size: CGSize) {
        node = SKSpriteNode()
        
        backdrop = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        backdrop.name = "upgradeBackdrop"
        backdrop.fillColor = SKColor.black
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backdrop.alpha = 0.90
        backdrop.lineWidth = 0
        backdrop.zPosition = 100
        
        upgradeMenuBackground =  SKShapeNode(rectOf: CGSize(width: size.width / 3, height: size.height * 0.75))
        upgradeMenuBackground.name = "upgradeMenuBackground"
        upgradeMenuBackground.fillColor = UpgradeInterface.backgroundColor
        upgradeMenuBackground.position = CGPoint(x: size.width / 4, y: size.height / 2)
        upgradeMenuBackground.lineWidth = 6
        upgradeMenuBackground.zPosition = 101
        
        titleLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 12);
        titleLabel.borderColor = UIColor.black
        titleLabel.borderWidth = titleLabel.fontSize / 4.5
        titleLabel.outlinedText = "UPGRADES"
        titleLabel.name = "upgradeTitle"
        titleLabel.fontColor = UIColor.white
        titleLabel.zPosition = 150
        titleLabel.position =  CGPoint(x: upgradeMenuBackground.position.x, y: upgradeMenuBackground.position.y + upgradeMenuBackground.frame.size.height * 0.45)
        
        nextWaveBackground = SKShapeNode(rectOf: CGSize(width: size.width / 3, height: size.height * 0.1))
        nextWaveBackground.name = "nextWaveBackground"
        nextWaveBackground.fillColor = UpgradeInterface.backgroundColor
        nextWaveBackground.position = CGPoint(x: size.width * 0.75, y: size.height * 0.125 + (nextWaveBackground.frame.height / 2))
        nextWaveBackground.lineWidth = 6
        nextWaveBackground.zPosition = 101
        
        nextWaveLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 12);
        nextWaveLabel.borderColor = UIColor.black
        nextWaveLabel.borderWidth = nextWaveLabel.fontSize / 4.5
        nextWaveLabel.outlinedText = "NEXT WAVE"
        nextWaveLabel.name = "nextWaveLabel"
        nextWaveLabel.fontColor = UIColor.white
        nextWaveLabel.zPosition = 150
        nextWaveLabel.position =  CGPoint(x: nextWaveBackground.position.x, y: nextWaveBackground.position.y - (nextWaveLabel.frame.height / 2))
        
        statsBackground = SKShapeNode(rectOf: CGSize(width: size.width / 3, height: size.height * 0.5))
        statsBackground.name = "statsBackground"
        statsBackground.fillColor = UpgradeInterface.backgroundColor
        statsBackground.position = CGPoint(x: size.width * 0.75, y: size.height * 0.625)
        statsBackground.lineWidth = 6
        statsBackground.zPosition = 101
        
        statsTitleLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 12);
        statsTitleLabel.borderColor = UIColor.black
        statsTitleLabel.borderWidth = statsTitleLabel.fontSize / 4.5
        statsTitleLabel.outlinedText = "STATS"
        statsTitleLabel.name = "statsTitle"
        statsTitleLabel.fontColor = UIColor.white
        statsTitleLabel.zPosition = 150
        statsTitleLabel.position =  CGPoint(x: statsBackground.position.x, y: titleLabel.position.y)
        
        node.addChild(statsBackground)
        node.addChild(titleLabel)
        node.addChild(backdrop)
        node.addChild(upgradeMenuBackground)
        node.addChild(nextWaveBackground)
        node.addChild(nextWaveLabel)
        node.addChild(statsTitleLabel)
    }
}
