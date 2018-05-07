//
//  GameScene.swift
//  d-fence
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let despawnBound:CGFloat = 32 // points
    let background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    var upgradeInterface: UpgradeInterface?
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var scout: Scout!
    var healthLabel: SKOutlinedLabelNode!
    var scoreLabel: SKOutlinedLabelNode!
    var coinsLabel: SKOutlinedLabelNode!
    var waveLabel: SKOutlinedLabelNode!
    
    var shots = [Shot]()
    var touchPosition: CGPoint!
    var fireTimestamp: Date?
    var fireTimer: Timer?
    
    var livingEnemies = [Enemy]()
    var waveCount: Int = 0
    var coins: Int = 0
    var score: Int = 0
    var isGameOver: Bool = false
    var isInUpgradeOverlay: Bool = false
    
    let defaults = UserDefaults.standard
    
    func startNewGame() {
        initScout()
        initLabels()
        Enemy.initWaves(height: size.height, width: size.width)
        spawnNextWave()
    }
    
    func spawnNextWave() {
        waveCount += 1
        waveLabel.outlinedText = NSLocalizedString("WAVE", comment: "") + " \(waveCount)"
        waveLabel.text = NSLocalizedString("WAVE", comment: "") + " \(waveCount)"
        
        print("Spawning wave \(waveCount)...")
        
        livingEnemies = Enemy.getWave(wave: waveCount)
        
        for enemy in livingEnemies {
            let random = arc4random_uniform(5)
            if random == 0 {
                Sound.play(file: "zombieidle.wav")
            } else if random == 1 {
                Sound.play(file: "zombieidle2.wav")
            } else if random == 2 {
                Sound.play(file: "zombieidle3.wav")
            } else if random == 3 {
                Sound.play(file: "zombieidle4.wav")
            } else {
                Sound.play(file: "zombieidle5.wav")
            }
            
            addChild(enemy.node)
        }
    }
    
    override func didMove(to view: SKView) {
        initBackground()
        startNewGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        updateShots()
        updateEnemies()
    }
    
    func updateLabels() {
        waveLabel.outlinedText = NSLocalizedString("WAVE", comment: "") + " \(waveCount)"
        coinsLabel.outlinedText = "\(coins) C"
        scoreLabel.outlinedText = NSLocalizedString("SCORE", comment: "") + " \(score)"
        healthLabel.outlinedText = NSLocalizedString("HP", comment: "") + ": \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
    }
    
    func updateEnemies() {
        let diffEdgeToScout = Utils.vectorAbs(vector: CGPoint(x: 0 - scout.node.position.x, y: size.height-scout.node.position.y))
        for enemy in livingEnemies {
            let node = enemy.node
            
            let differenceToScout = Utils.vectorAbs(vector: CGPoint(x: scout.node.position.x - node.position.x, y: scout.node.position.y - node.position.y))
            
            if !enemy.hasScreamed && differenceToScout <= (diffEdgeToScout / 2) {
                let random = arc4random_uniform(5)
                if random == 0 {
                    Sound.play(file: "zombieidle.wav")
                } else if random == 1 {
                    Sound.play(file: "zombieidle2.wav")
                } else if random == 2 {
                    Sound.play(file: "zombieidle3.wav")
                } else if random == 3 {
                    Sound.play(file: "zombieidle4.wav")
                } else {
                    Sound.play(file: "zombieidle5.wav")
                }
                enemy.hasScreamed = true
            }
            
            if differenceToScout > ((scout.node.size.width / 3) * 2) {
                node.position = CGPoint(x: node.position.x + (enemy.direction.x * CGFloat(dt)), y: node.position.y + (enemy.direction.y * CGFloat(dt)))
            } else {
                node.removeAllActions()
                if !enemy.eating {
                    enemy.startEating(eat: handleBite)
                }
            }
        }
    }
    
    func handleWaveEnd() {
        if (Enemy.getWave(wave: waveCount+1).isEmpty) {
            print("We don't have any more waves...")
            gameWon()
        } else {
            showUpgradeInterface()
        }
    }
    
    func handleBite(enemy: Enemy) {
        let random = arc4random_uniform(3)
        if random == 0 {
            Sound.play(file: "zombiechews.wav")
        } else if random == 1 {
            Sound.play(file: "zombiechews2.wav")
        } else if random == 2 {
            Sound.play(file: "zombiechews3.wav")
        }
        
        scout.currentHealthPoints -= enemy.damage
        healthLabel.outlinedText = NSLocalizedString("HP", comment: "") + ": \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
        healthLabel.text = NSLocalizedString("HP", comment: "") + ": \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
        if scout.currentHealthPoints <= 0 {
            scout.currentHealthPoints = 0
            healthLabel.outlinedText = NSLocalizedString("HP", comment: "") + ": 0/\(scout.maxHealthPoints)"
            gameOver()
        }
    }
    
    func handleShotHit(shot: Shot, enemy: Enemy) {
        Sound.play(file: "bullethits.wav")
        
        enemy.currentHealthPoints -= scout.damage
        if (enemy.currentHealthPoints <= 0) {
            let random = arc4random_uniform(13)
            if random < 4 {
                Sound.play(file: "zombiedies.wav")
            } else if random < 8 {
                Sound.play(file: "zombiedies2.wav")
            } else if random < 10 {
                Sound.play(file: "zombiedies3.wav")
            }
            
            enemy.currentHealthPoints = 0
            coins += enemy.getValue() * GameConstants.coinsMultiplier
            coinsLabel.outlinedText = "\(coins) C"
            score += enemy.getValue() * Int(Utils.vectorDistance(vectorA: enemy.node.position, vectorB: scout.node.position)) / GameConstants.scoreDivisor
            scoreLabel.outlinedText = NSLocalizedString("SCORE", comment: "") + " \(score)"
            scoreLabel.text = NSLocalizedString("SCORE", comment: "") + " \(score)"
            despawnEnemy(enemy: enemy)
            if livingEnemies.count == 0 {
                handleWaveEnd()
            }
        } else {
            let random = arc4random_uniform(4)
            if random == 0 {
                Sound.play(file: "zombiehit.wav")
            } else if random == 1 {
                Sound.play(file: "zombiehit2.wav")
            } else if random == 2 {
                Sound.play(file: "zombiehit3.wav")
            } else {
                Sound.play(file: "zombiehit4.wav")
            }
        }
        despawnShot(shot: shot)
    }
    
    func despawnEnemy(enemy: Enemy) {
        enemy.node.removeFromParent()
        enemy.stopEating()
        if let timer = enemy.eatingTimer {
            timer.invalidate()
        }
        if let index = livingEnemies.index(of: enemy) {
            livingEnemies.remove(at: index)
        }
    }
    
    func despawnShot(shot: Shot) {
        shot.node.removeFromParent()
        if let index = shots.index(of: shot) {
            shots.remove(at: index)
        }
    }
    
    func updateShots() {
        shotUpdate: for shot in shots {
            // Check for collisions
            for enemy in livingEnemies {
                if enemy.node.frame.intersects(shot.node.frame) {
                    handleShotHit(shot: shot, enemy: enemy)
                    continue shotUpdate // with next shot
                }
            }
            
            shot.node.position = CGPoint(x: shot.node.position.x + (shot.direction.x * CGFloat(dt)), y: shot.node.position.y + (shot.direction.y * CGFloat(dt)))
            
            // Remove all nodes which are out of the screen
            if (shot.node.position.x < -despawnBound || shot.node.position.x > size.width + despawnBound || shot.node.position.y < -despawnBound || shot.node.position.y > size.height + despawnBound) {
                despawnShot(shot: shot)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        
        if !isGameOver && !isInUpgradeOverlay{
            if let name = touchedNode.name {
                if name == "scout" {
                    print("User clicked scout")
                } else if name == "enemy"{
//                    scout.updateRotation(touchPoint: touchPosition)
                    tryToFire()
                }
            } else {
//                scout.updateRotation(touchPoint: touchPosition)
                tryToFire()
            }
        } else {
            if let name = touchedNode.name {
                if name == "gameOverBackLabel" || name == "gameWonBackLabel" {
                    
                    for enemy in livingEnemies {
                        despawnEnemy(enemy: enemy)
                    }
                    
                    let reveal = SKTransition.push(with: SKTransitionDirection.right, duration: 0.5)
                    view?.presentScene(MainMenuScene(size: self.size), transition: reveal)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        
        if !isGameOver && !isInUpgradeOverlay {
            if let name = touchedNode.name {
                if name == "scout" {
                    fireTimer?.invalidate()
                } else if name == "enemy" {
//                    scout.updateRotation(touchPoint: touchPosition)
                    tryToFire()
                }
            } else {
//                scout.updateRotation(touchPoint: touchPosition)
                tryToFire()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTimer?.invalidate()
        let touch = touches.first!
        touchPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        if isInUpgradeOverlay {
            if let name = touchedNode.name {
                if name == "nextWaveBackground" || name == "nextWaveLabel" {
                    Sound.play(file: "slingshotfires.wav")
                    spawnNextWave()
                    hideUpgradeInterface()
                } else if name == "upgradeHeal" || name == "upgradeHealBuy" {
                    Sound.play(file: "slingshotfires.wav")
                    coins -= upgradeInterface!.buyUpgrade(upgradeIndex: UpgradeInterface.Upgrade.REPAIR, scout: scout, coins: coins)
                    updateLabels()
                    upgradeInterface!.updateLabels(scout: scout, score: score, coins: coins, wave: waveCount)
                } else if name == "upgradePistol" || name == "upgradePistolBuy" {
                    Sound.play(file: "slingshotfires.wav")
                    coins -= upgradeInterface!.buyUpgrade(upgradeIndex: UpgradeInterface.Upgrade.PISTOL, scout: scout, coins: coins)
                    updateLabels()
                    upgradeInterface!.updateLabels(scout: scout, score: score, coins: coins, wave: waveCount)
                } else if name == "upgradeLasergun" || name == "upgradeLasergunBuy" {
                    Sound.play(file: "slingshotfires.wav")
                    coins -= upgradeInterface!.buyUpgrade(upgradeIndex: UpgradeInterface.Upgrade.LASERGUN, scout: scout, coins: coins)
                    updateLabels()
                    upgradeInterface!.updateLabels(scout: scout, score: score, coins: coins, wave: waveCount)
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTimer?.invalidate()
    }
    
    func tryToFire() {
        let sinceLastFiringAttempt = Date().timeIntervalSince(fireTimestamp ?? Date(timeIntervalSince1970: 0));
        
        if (sinceLastFiringAttempt > scout.fireCooldown) {
            if let fT = fireTimer {
                fT.invalidate()
            }
            fireTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(scout.fireCooldown), repeats: true) { (timer) in
                self.tryToFire();
            }
            fireTimestamp = Date()
            initShot(touchPoint: touchPosition)
        }
    }
    
    func showUpgradeInterface() {
        isInUpgradeOverlay = true
    
        upgradeInterface = UpgradeInterface(size: self.size, scout: scout, score: score, coins: coins, wave: waveCount)
        addChild(upgradeInterface!.node)
    }
    
    func hideUpgradeInterface() {
        isInUpgradeOverlay = false
        
        upgradeInterface?.node.removeFromParent()
        upgradeInterface = nil
    }
    
    func gameWon() {
        isGameOver = true
        
        let backdrop = SKShapeNode(rectOf: CGSize(width: size.width * 6, height: size.height * 6))
        backdrop.name = "gameWonBackdrop"
        backdrop.fillColor = SKColor.black
        backdrop.position = CGPoint.zero
        backdrop.alpha = 0.8
        backdrop.lineWidth = 0
        backdrop.zPosition = 1000
        
        let gameWonLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
        gameWonLabel.name = "gameWonLabel"
        gameWonLabel.text = NSLocalizedString("YOU SURVIVED", comment: "")
        gameWonLabel.fontColor = SKColor.white
        gameWonLabel.zPosition = 1001
        gameWonLabel.fontSize = size.height / 5
        gameWonLabel.position = CGPoint(x: size.width / 2, y: (size.height / 3) * 2)
        
        let gameWonScoreLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
        gameWonScoreLabel.name = "gameWonScoreLabel"
        gameWonScoreLabel.text = NSLocalizedString("SCORE", comment: "") + " \(score)"
        gameWonScoreLabel.fontColor = SKColor.white
        gameWonScoreLabel.zPosition = 1001
        gameWonScoreLabel.fontSize = size.height / 10
        gameWonScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let gameWonBackLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
        gameWonBackLabel.name = "gameWonBackLabel"
        gameWonBackLabel.text = NSLocalizedString("BACK", comment: "")
        gameWonBackLabel.fontColor = SKColor.white
        gameWonBackLabel.zPosition = 1001
        gameWonBackLabel.fontSize = size.height / 10
        gameWonBackLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) - (gameWonScoreLabel.frame.size.height * 4))
        
        addChild(backdrop)
        addChild(gameWonLabel)
        addChild(gameWonScoreLabel)
        addChild(gameWonBackLabel)
        writeInHighscore()
    }
    
    func gameOver() {
        if !isGameOver {
            isGameOver = true
        
            let backdrop = SKShapeNode(rectOf: CGSize(width: size.width * 6, height: size.height * 6))
            backdrop.name = "gameOverBackdrop"
            backdrop.fillColor = SKColor.black
            backdrop.position = CGPoint.zero
            backdrop.alpha = 0.8
            backdrop.lineWidth = 0
            backdrop.zPosition = 1000
        
            let gameOverLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
            gameOverLabel.name = "gameOverLabel"
            gameOverLabel.text = NSLocalizedString("GAME OVER", comment: "")
            gameOverLabel.fontColor = SKColor.white
            gameOverLabel.zPosition = 1001
            gameOverLabel.fontSize = size.height / 5
            gameOverLabel.position = CGPoint(x: size.width / 2, y: (size.height / 3) * 2)
        
            let gameOverScoreLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
            gameOverScoreLabel.name = "gameOverScoreLabel"
            gameOverScoreLabel.text = NSLocalizedString("SCORE", comment: "") + " \(score)"
            gameOverScoreLabel.fontColor = SKColor.white
            gameOverScoreLabel.zPosition = 1001
            gameOverScoreLabel.fontSize = size.height / 10
            gameOverScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
            let gameOverWaveLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
            gameOverWaveLabel.name = "gameOverWaveLabel"
            gameOverWaveLabel.text = NSLocalizedString("WAVE", comment: "") + " \(waveCount)"
            gameOverWaveLabel.fontColor = SKColor.white
            gameOverWaveLabel.zPosition = 1001
            gameOverWaveLabel.fontSize = size.height / 10
            gameOverWaveLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) - (gameOverScoreLabel.frame.size.height * 1.5))
            
            let gameOverBackLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
            gameOverBackLabel.name = "gameOverBackLabel"
            gameOverBackLabel.text = NSLocalizedString("BACK", comment: "")
            gameOverBackLabel.fontColor = SKColor.white
            gameOverBackLabel.zPosition = 1001
            gameOverBackLabel.fontSize = size.height / 10
            gameOverBackLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) - (gameOverScoreLabel.frame.size.height * 4))
            
            addChild(backdrop)
            addChild(gameOverLabel)
            addChild(gameOverScoreLabel)
            addChild(gameOverWaveLabel)
            addChild(gameOverBackLabel)
            writeInHighscore()
        }
    }
    
    func initLabels() {
        // Health label
        healthLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        healthLabel.borderColor = UIColor.black
        healthLabel.borderWidth = healthLabel.fontSize / 4.5
        healthLabel.outlinedText = NSLocalizedString("HP", comment: "") + ": \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
        
        healthLabel.name = "healthLabel"
        healthLabel.fontColor = SKColor.white
        healthLabel.zPosition = 15
        healthLabel.position = CGPoint(x: size.width * 0.25, y: self.size.height / 100)
        
        // Score label
        scoreLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        scoreLabel.borderColor = UIColor.black
        scoreLabel.borderWidth = scoreLabel.fontSize / 4.5
        scoreLabel.outlinedText = NSLocalizedString("SCORE", comment: "") + " \(score)"
        
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 15
        scoreLabel.position = CGPoint(x: size.width * 0.75, y: self.size.height / 100)
        
        // Wave label
        waveLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        waveLabel.borderColor = UIColor.black
        waveLabel.borderWidth = waveLabel.fontSize / 4.5
        waveLabel.outlinedText = NSLocalizedString("WAVE", comment: "") + " \(waveCount)"
        waveLabel.name = "waveLabel"
        waveLabel.fontColor = SKColor.white
        waveLabel.fontSize = self.size.height / 25
        waveLabel.zPosition = 15
        waveLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.99 - waveLabel.frame.size.height)
        
        // Coins label
        coinsLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        coinsLabel.borderColor = UIColor.black
        coinsLabel.borderWidth = coinsLabel.fontSize / 4.5
        coinsLabel.outlinedText = "\(coins) C"
        coinsLabel.name = "coinsLabel"
        coinsLabel.fontColor = SKColor.white
        coinsLabel.fontSize = self.size.height / 25
        coinsLabel.zPosition = 15
        coinsLabel.position = CGPoint(x: size.width - coinsLabel.frame.size.width, y: size.height * 0.99 - waveLabel.frame.size.height)
        
        addChild(coinsLabel)
        addChild(waveLabel)
        addChild(healthLabel)
        addChild(scoreLabel)
    }
    
    func initShot(touchPoint: CGPoint) {
        var upgrade: String = ""
        switch scout.upgrade {
        case UpgradeInterface.Upgrade.STONE:
            Sound.play(file: "slingshotfires.wav")
            upgrade = "stoneBullet"
            break
        case UpgradeInterface.Upgrade.PISTOL:
            upgrade = "cartridgeBullet"
            let random = arc4random_uniform(10)
            if random < 8 {
                Sound.play(file: "gunfire1.wav")
            } else if random == 9 {
                Sound.play(file: "gunfire2.wav")
            } else if random == 8 {
                Sound.play(file: "gunfire3.wav")
            }
            break
        case UpgradeInterface.Upgrade.LASERGUN:
            upgrade = "laserBullet"
            Sound.play(file: "laser.wav")
            break
        default:
            break
        }
        let newShot = Shot(size: self.size, scoutPosition: scout.node.position, direction: scout.calculateDirectionOfShot(size: self.size, touchPoint: touchPoint), upgrade: upgrade)
        
        shots.append(newShot)
        
        addChild(newShot.node)
    }
    
    func initScout() {
        scout = Scout(size: self.size)
        scout.currentHealthPoints = scout.maxHealthPoints
        
        addChild(scout.node)
    }
    
    func initBackground() {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        background.scale(to: self.size)
        
        addChild(background)
    }
    
    func writeInHighscore() {
        var num_entries = 0
        if defaults.value(forKey: "num_entries") != nil {
            num_entries = defaults.value(forKey: "num_entries") as! Int
        }
        if num_entries > 0 {
            var found = false
            var scores_change = [0,0,0,0,0,0,0,0,0,0]
            var waves_change = [0,0,0,0,0,0,0,0,0,0]
            var k = 1
            if num_entries > 9 {
                k = 1
            }  else {
                k = num_entries - abs(num_entries - 10)
            }
            for i in 0...num_entries - k {
                if defaults.value(forKey: "score\(i)") != nil && found == false {
                    let k = defaults.value(forKey: "score\(i)") as? Int
                    if k! < self.score {
                        scores_change[i] = score
                        waves_change[i] = waveCount
                        scores_change[i + 1] = defaults.value(forKey: "score\(i)")! as! Int
                        waves_change[i + 1] = defaults.value(forKey: "wave\(i)")! as! Int
                        found = true
                    }
                    else {
                        scores_change[i] = defaults.value(forKey: "score\(i)")! as! Int
                        waves_change[i] = defaults.value(forKey: "wave\(i)")! as! Int
                    }
                }
                else if defaults.value(forKey: "score\(i)") != nil && found == true {
                    scores_change[i + 1] = defaults.value(forKey: "score\(i)")! as! Int
                    waves_change[i + 1] = defaults.value(forKey: "wave\(i)")! as! Int
                }
            }
            for i in 0...scores_change.count - 1  {
                defaults.set(scores_change[i], forKey: "score\(i)")
                defaults.set(waves_change[i], forKey: "wave\(i)")
            }
        }
        else {
            defaults.set(score, forKey: "score0")
            defaults.set(waveCount, forKey: "wave0")
        }
        if num_entries < 10 {
            num_entries = num_entries + 1
            defaults.set(num_entries, forKey: "num_entries")
        }
    }
}
