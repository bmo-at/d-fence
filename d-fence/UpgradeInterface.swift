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
    let upgradeTitleLabel: SKOutlinedLabelNode
    
    let statsTitleLabel: SKOutlinedLabelNode
    let statsWaveLabel: SKOutlinedLabelNode
    let statsHealthLabel: SKOutlinedLabelNode
    let statsScoreLabel: SKOutlinedLabelNode
    let statsCoinsLabel: SKOutlinedLabelNode
    
    let nextWaveLabel: SKOutlinedLabelNode
    
    required init(size: CGSize, scout: Scout, score:Int, coins:Int, wave:Int) {
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
        
        upgradeTitleLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 12);
        upgradeTitleLabel.borderColor = UIColor.black
        upgradeTitleLabel.borderWidth = upgradeTitleLabel.fontSize / 4.5
        upgradeTitleLabel.outlinedText = "UPGRADES"
        upgradeTitleLabel.name = "upgradeTitle"
        upgradeTitleLabel.fontColor = UIColor.white
        upgradeTitleLabel.zPosition = 150
        upgradeTitleLabel.position =  CGPoint(x: upgradeMenuBackground.position.x, y: upgradeMenuBackground.position.y + upgradeMenuBackground.frame.size.height * 0.45)
        
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
        statsTitleLabel.position =  CGPoint(x: statsBackground.position.x, y: upgradeTitleLabel.position.y)
        
        statsWaveLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 16);
        statsWaveLabel.borderColor = UIColor.black
        statsWaveLabel.borderWidth = statsWaveLabel.fontSize / 4.5
        statsWaveLabel.outlinedText = "Wave: \(wave+1)"
        statsWaveLabel.name = "statsWave"
        statsWaveLabel.fontColor = UIColor.white
        statsWaveLabel.zPosition = 150
        statsWaveLabel.position =  CGPoint(x: statsTitleLabel.position.x, y: statsBackground.position.y + statsWaveLabel.frame.size.height * 4.5)
        
        statsHealthLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 16);
        statsHealthLabel.borderColor = UIColor.black
        statsHealthLabel.borderWidth = statsHealthLabel.fontSize / 4.5
        statsHealthLabel.outlinedText = "\(scout.currentHealthPoints)/\(scout.maxHealthPoints) HP"
        statsHealthLabel.name = "statsHealth"
        statsHealthLabel.fontColor = UIColor.white
        statsHealthLabel.zPosition = 150
        statsHealthLabel.position =  CGPoint(x: statsTitleLabel.position.x, y: statsBackground.position.y + statsHealthLabel.frame.size.height * 1.0)
        
        statsScoreLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 16);
        statsScoreLabel.borderColor = UIColor.black
        statsScoreLabel.borderWidth = statsScoreLabel.fontSize / 4.5
        statsScoreLabel.outlinedText = "SCORE: \(score)"
        statsScoreLabel.name = "statsScore"
        statsScoreLabel.fontColor = UIColor.white
        statsScoreLabel.zPosition = 150
        statsScoreLabel.position =  CGPoint(x: statsTitleLabel.position.x, y: statsBackground.position.y - statsScoreLabel.frame.size.height * 2.5)
        
        statsCoinsLabel = SKOutlinedLabelNode(fontNamed: "8-Bit Madness", fontSize: size.height / 16);
        statsCoinsLabel.borderColor = UIColor.black
        statsCoinsLabel.borderWidth = statsCoinsLabel.fontSize / 4.5
        statsCoinsLabel.outlinedText = "\(coins) COINS"
        statsCoinsLabel.name = "statsCoins"
        statsCoinsLabel.fontColor = UIColor.white
        statsCoinsLabel.zPosition = 150
        statsCoinsLabel.position =  CGPoint(x: statsTitleLabel.position.x, y: statsBackground.position.y - statsCoinsLabel.frame.size.height * 6.0)
        
        node.addChild(statsBackground)
        node.addChild(statsTitleLabel)
        node.addChild(statsWaveLabel)
        node.addChild(statsHealthLabel)
        node.addChild(statsScoreLabel)
        node.addChild(statsCoinsLabel)
        
        node.addChild(upgradeMenuBackground)
        node.addChild(upgradeTitleLabel)
        
        node.addChild(backdrop)
        
        node.addChild(nextWaveBackground)
        node.addChild(nextWaveLabel)
    }
}
