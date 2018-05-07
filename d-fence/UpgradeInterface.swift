//
//  UpgradeInterface.swift
//  d-fence
//

import SpriteKit



class UpgradeInterface {
    enum Upgrade {
        case STONE, PISTOL, LASERGUN, REPAIR
    }
    
    static let backgroundColor: SKColor = SKColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    
    let node: SKSpriteNode
    let backdrop: SKShapeNode
    let upgradeMenuBackground: SKShapeNode
    let nextWaveBackground: SKShapeNode
    let statsBackground: SKShapeNode
    
    let upgradeTitleLabel: SKOutlinedLabelNode
    let healLabel: SKOutlinedLabelNode
    let healBuyLabel: SKOutlinedLabelNode
    let slingshotLabel: SKOutlinedLabelNode
    let slingshotBuyLabel: SKOutlinedLabelNode
    let pistolLabel: SKOutlinedLabelNode
    let pistolBuyLabel: SKOutlinedLabelNode
    let laserLabel: SKOutlinedLabelNode
    let laserBuyLabel: SKOutlinedLabelNode
    
    let statsTitleLabel: SKOutlinedLabelNode
    let statsWaveLabel: SKOutlinedLabelNode
    let statsHealthLabel: SKOutlinedLabelNode
    let statsScoreLabel: SKOutlinedLabelNode
    let statsCoinsLabel: SKOutlinedLabelNode
    
    let nextWaveLabel: SKOutlinedLabelNode
    
    func updateUpgrades(scout: Scout, score:Int, coins:Int, wave:Int) {
        healBuyLabel.fontColor = scout.currentHealthPoints < scout.maxHealthPoints && coins >= GameConstants.treehouseRepairCosts ? UIColor.white : UIColor.gray
        
        if (scout.upgrade == Upgrade.PISTOL || scout.upgrade == Upgrade.LASERGUN) {
            pistolBuyLabel.outlinedText = NSLocalizedString("DONE", comment: "")
            pistolBuyLabel.fontColor = UIColor.gray
        } else {
            pistolBuyLabel.outlinedText = "\(GameConstants.pistolCosts / 1000)k C"
            pistolBuyLabel.fontColor = coins >= GameConstants.pistolCosts ? UIColor.white : UIColor.gray
        }
        
        if (scout.upgrade == Upgrade.LASERGUN) {
            laserBuyLabel.outlinedText = NSLocalizedString("DONE", comment: "")
            laserBuyLabel.fontColor = UIColor.gray
        } else if (scout.upgrade == Upgrade.PISTOL) {
            laserBuyLabel.outlinedText = "\(GameConstants.laserCosts / 1000)k C"
            laserBuyLabel.fontColor = coins >= GameConstants.laserCosts ? UIColor.white : UIColor.gray
        } else {
            laserBuyLabel.outlinedText = NSLocalizedString("LOCKED", comment: "")
            laserBuyLabel.fontColor = UIColor.gray
        }
    }
    
    func updateStats(scout: Scout, score:Int, coins:Int, wave:Int) {
        statsWaveLabel.outlinedText = NSLocalizedString("WAVE", comment: "") + ": \(wave+1)"
        statsHealthLabel.outlinedText = "\(scout.currentHealthPoints)/\(scout.maxHealthPoints) HP"
        statsScoreLabel.outlinedText = NSLocalizedString("SCORE", comment: "") + ": \(score)"
        statsCoinsLabel.outlinedText = "\(coins) " + NSLocalizedString("COINS", comment: "")
    }
    
    func updateLabels(scout: Scout, score:Int, coins:Int, wave:Int) {
        updateStats(scout: scout, score: score, coins: coins, wave: wave)
        updateUpgrades(scout: scout, score: score, coins: coins, wave: wave)
    }
    
    // returns the costs
    func buyUpgrade(upgradeIndex: Upgrade, scout: Scout, coins: Int) -> Int {
        switch upgradeIndex {
        case Upgrade.STONE:
            break;
        case Upgrade.PISTOL:
            if (scout.upgrade == Upgrade.STONE && coins >= GameConstants.pistolCosts) {
                scout.damage = GameConstants.pistolDamage
                scout.bulletVelocity = GameConstants.pistolVelocity
                scout.fireCooldown = GameConstants.pistolCooldown
                scout.upgrade = Upgrade.PISTOL
                return GameConstants.pistolCosts
            }
        case Upgrade.LASERGUN:
            if (scout.upgrade == Upgrade.PISTOL && coins >= GameConstants.laserCosts) {
                scout.damage = GameConstants.laserDamage
                scout.bulletVelocity = GameConstants.laserVelocity
                scout.fireCooldown = GameConstants.laserCooldown
                scout.upgrade = Upgrade.LASERGUN
                return GameConstants.laserCosts
            }
        case Upgrade.REPAIR:
            if (scout.currentHealthPoints < scout.maxHealthPoints && coins >= GameConstants.treehouseRepairCosts) {
                scout.currentHealthPoints = scout.currentHealthPoints <= scout.maxHealthPoints - CGFloat(GameConstants.treehouseRepairValue) ? scout.currentHealthPoints + CGFloat(GameConstants.treehouseRepairValue) : scout.maxHealthPoints
                return GameConstants.treehouseRepairCosts
            }
        }
        print("Upgrade denied by game logic.")
        return 0
    }
    
    required init(size: CGSize, scout: Scout, score:Int, coins:Int, wave:Int) {
        node = SKSpriteNode()
        
        backdrop = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        backdrop.name = "upgradeBackdrop"
        backdrop.fillColor = SKColor.black
        backdrop.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backdrop.alpha = 0.8
        backdrop.lineWidth = 0
        backdrop.zPosition = 100
        
        upgradeMenuBackground =  SKShapeNode(rectOf: CGSize(width: size.width / 3, height: size.height * 0.75))
        upgradeMenuBackground.name = "upgradeMenuBackground"
        upgradeMenuBackground.fillColor = UpgradeInterface.backgroundColor
        upgradeMenuBackground.position = CGPoint(x: size.width / 4, y: size.height / 2)
        upgradeMenuBackground.lineWidth = 6
        upgradeMenuBackground.zPosition = 101
        
        upgradeTitleLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 14);
        upgradeTitleLabel.borderColor = UIColor.black
        upgradeTitleLabel.borderWidth = upgradeTitleLabel.fontSize / 4.5
        upgradeTitleLabel.outlinedText = NSLocalizedString("UPGRADE", comment: "")
        upgradeTitleLabel.name = "upgradeTitle"
        upgradeTitleLabel.fontColor = UIColor.white
        upgradeTitleLabel.zPosition = 150
        upgradeTitleLabel.position =  CGPoint(x: upgradeMenuBackground.position.x, y: upgradeMenuBackground.position.y + upgradeMenuBackground.frame.size.height * 0.45)
        
        healLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        healLabel.borderColor = UIColor.black
        healLabel.borderWidth = healLabel.fontSize / 4.5
        healLabel.outlinedText = NSLocalizedString("REPAIR", comment: "")
        healLabel.name = "upgradeHeal"
        healLabel.fontColor = UIColor.white
        healLabel.zPosition = 150
        healLabel.position =  CGPoint(x: upgradeMenuBackground.position.x - (upgradeMenuBackground.frame.width * 0.45) + (healLabel.frame.width / 2), y: upgradeMenuBackground.position.y * 0.333)
        
        healBuyLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        healBuyLabel.borderColor = UIColor.black
        healBuyLabel.borderWidth = healBuyLabel.fontSize / 4.5
        healBuyLabel.outlinedText = "\(GameConstants.treehouseRepairCosts) C"
        healBuyLabel.name = "upgradeHealBuy"
        healBuyLabel.zPosition = 150
        healBuyLabel.position =  CGPoint(x: upgradeMenuBackground.position.x + (upgradeMenuBackground.frame.width * 0.25), y: healLabel.position.y)
        
        slingshotLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        slingshotLabel.borderColor = UIColor.black
        slingshotLabel.borderWidth = slingshotLabel.fontSize / 4.5
        slingshotLabel.outlinedText = NSLocalizedString("SLINGSHOT", comment: "")
        slingshotLabel.name = "upgradeSlingshot"
        slingshotLabel.fontColor = UIColor.white
        slingshotLabel.zPosition = 150
        slingshotLabel.position =  CGPoint(x: upgradeMenuBackground.position.x - (upgradeMenuBackground.frame.width * 0.45) + (slingshotLabel.frame.width / 2), y: upgradeMenuBackground.position.y * 1.5)
        
        slingshotBuyLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        slingshotBuyLabel.borderColor = UIColor.black
        slingshotBuyLabel.borderWidth = slingshotBuyLabel.fontSize / 4.5
        slingshotBuyLabel.outlinedText = NSLocalizedString("DONE", comment: "")
        slingshotBuyLabel.fontColor = UIColor.gray
        slingshotBuyLabel.name = "upgradeSlingshotBuy"
        slingshotBuyLabel.zPosition = 150
        slingshotBuyLabel.position =  CGPoint(x: upgradeMenuBackground.position.x + (upgradeMenuBackground.frame.width * 0.25), y: slingshotLabel.position.y)
        
        pistolLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        pistolLabel.borderColor = UIColor.black
        pistolLabel.borderWidth = pistolLabel.fontSize / 4.5
        pistolLabel.outlinedText = NSLocalizedString("PISTOL", comment: "")
        pistolLabel.name = "upgradePistol"
        pistolLabel.fontColor = UIColor.white
        pistolLabel.zPosition = 150
        pistolLabel.position =  CGPoint(x: upgradeMenuBackground.position.x - (upgradeMenuBackground.frame.width * 0.45) + (pistolLabel.frame.width / 2), y: upgradeMenuBackground.position.y * 1.25)
        
        pistolBuyLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        pistolBuyLabel.borderColor = UIColor.black
        pistolBuyLabel.borderWidth = pistolBuyLabel.fontSize / 4.5
        pistolBuyLabel.name = "upgradePistolBuy"
        pistolBuyLabel.zPosition = 150
        pistolBuyLabel.position =  CGPoint(x: upgradeMenuBackground.position.x + (upgradeMenuBackground.frame.width * 0.25), y: pistolLabel.position.y)
        
        laserLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        laserLabel.borderColor = UIColor.black
        laserLabel.borderWidth = laserLabel.fontSize / 4.5
        laserLabel.outlinedText = NSLocalizedString("LASERGUN", comment: "")
        laserLabel.name = "upgradeLasergun"
        laserLabel.fontColor = UIColor.white
        laserLabel.zPosition = 150
        laserLabel.position =  CGPoint(x: upgradeMenuBackground.position.x - (upgradeMenuBackground.frame.width * 0.45) + (laserLabel.frame.width / 2), y: upgradeMenuBackground.position.y * 1.0)
        
        laserBuyLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        laserBuyLabel.borderColor = UIColor.black
        laserBuyLabel.borderWidth = laserBuyLabel.fontSize / 4.5
        laserBuyLabel.name = "upgradeLasergunBuy"
        laserBuyLabel.zPosition = 150
        laserBuyLabel.position =  CGPoint(x: upgradeMenuBackground.position.x + (upgradeMenuBackground.frame.width * 0.25), y: laserLabel.position.y)
        
        nextWaveBackground = SKShapeNode(rectOf: CGSize(width: size.width / 3, height: size.height * 0.1))
        nextWaveBackground.name = "nextWaveBackground"
        nextWaveBackground.fillColor = UpgradeInterface.backgroundColor
        nextWaveBackground.position = CGPoint(x: size.width * 0.75, y: size.height * 0.125 + (nextWaveBackground.frame.height / 2))
        nextWaveBackground.lineWidth = 6
        nextWaveBackground.zPosition = 101
        
        nextWaveLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 14);
        nextWaveLabel.borderColor = UIColor.black
        nextWaveLabel.borderWidth = nextWaveLabel.fontSize / 4.5
        nextWaveLabel.outlinedText = NSLocalizedString("NEXT WAVE", comment: "")
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
        
        statsTitleLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 14);
        statsTitleLabel.borderColor = UIColor.black
        statsTitleLabel.borderWidth = statsTitleLabel.fontSize / 4.5
        statsTitleLabel.outlinedText = NSLocalizedString("STATS", comment: "")
        statsTitleLabel.name = "statsTitle"
        statsTitleLabel.fontColor = UIColor.white
        statsTitleLabel.zPosition = 150
        statsTitleLabel.position =  CGPoint(x: statsBackground.position.x, y: upgradeTitleLabel.position.y)
        
        statsWaveLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        statsWaveLabel.borderColor = UIColor.black
        statsWaveLabel.borderWidth = statsWaveLabel.fontSize / 4.5
        statsWaveLabel.outlinedText = NSLocalizedString("WAVE", comment: "") + ": \(wave+1)"
        statsWaveLabel.name = "statsWave"
        statsWaveLabel.fontColor = UIColor.white
        statsWaveLabel.zPosition = 150
        statsWaveLabel.position =  CGPoint(x: statsTitleLabel.position.x, y: statsBackground.position.y + statsWaveLabel.frame.size.height * 4.5)
        
        statsHealthLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        statsHealthLabel.borderColor = UIColor.black
        statsHealthLabel.borderWidth = statsHealthLabel.fontSize / 4.5
        statsHealthLabel.outlinedText = "\(scout.currentHealthPoints)/\(scout.maxHealthPoints) HP"
        statsHealthLabel.name = "statsHealth"
        statsHealthLabel.fontColor = UIColor.white
        statsHealthLabel.zPosition = 150
        statsHealthLabel.position =  CGPoint(x: statsTitleLabel.position.x, y: statsBackground.position.y + statsHealthLabel.frame.size.height * 1.0)
        
        statsScoreLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        statsScoreLabel.borderColor = UIColor.black
        statsScoreLabel.borderWidth = statsScoreLabel.fontSize / 4.5
        statsScoreLabel.outlinedText = NSLocalizedString("SCORE", comment: "") + ": \(score)"
        statsScoreLabel.name = "statsScore"
        statsScoreLabel.fontColor = UIColor.white
        statsScoreLabel.zPosition = 150
        statsScoreLabel.position =  CGPoint(x: statsTitleLabel.position.x, y: statsBackground.position.y - statsScoreLabel.frame.size.height * 2.5)
        
        statsCoinsLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: size.height / 18);
        statsCoinsLabel.borderColor = UIColor.black
        statsCoinsLabel.borderWidth = statsCoinsLabel.fontSize / 4.5
        statsCoinsLabel.outlinedText = "\(coins) C"
        statsCoinsLabel.name = "statsCoins"
        statsCoinsLabel.fontColor = UIColor.yellow
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
        node.addChild(healLabel)
        node.addChild(healBuyLabel)
        node.addChild(slingshotLabel)
        node.addChild(slingshotBuyLabel)
        node.addChild(pistolLabel)
        node.addChild(pistolBuyLabel)
        node.addChild(laserLabel)
        node.addChild(laserBuyLabel)
        
        node.addChild(backdrop)
        
        node.addChild(nextWaveBackground)
        node.addChild(nextWaveLabel)
        
        updateLabels(scout: scout, score: score, coins: coins, wave: wave)
    }
}
