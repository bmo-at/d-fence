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
    
    func startNewGame() {
        initScout()
        initLabels()
        Enemy.initWaves(height: size.height, width: size.width)
        spawnNextWave()
    }
    
    func spawnNextWave() {
        waveCount += 1
        waveLabel.outlinedText = "WAVE \(waveCount)"
        waveLabel.text = "WAVE \(waveCount)"
        
        print("Spawning wave \(waveCount)...")
        
        livingEnemies = Enemy.getWave(wave: waveCount)
        
        for enemy in livingEnemies {
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
        waveLabel.outlinedText = "WAVE \(waveCount)"
        coinsLabel.outlinedText = "\(coins) COINS"
        scoreLabel.outlinedText = "SCORE: \(score)"
        healthLabel.outlinedText = "HP: \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
    }
    
    func updateEnemies() {
        for enemy in livingEnemies {
            let node = enemy.node
            
            let differenceToScout = CGPoint(x: scout.node.position.x - node.position.x, y: scout.node.position.y - node.position.y)
            
            if Utils.vectorAbs(vector: differenceToScout) > ((scout.node.size.width / 3) * 2) {
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
        scout.currentHealthPoints -= enemy.damage
        healthLabel.outlinedText = "HP: \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
        healthLabel.text = "HP: \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
        if scout.currentHealthPoints <= 0 {
            scout.currentHealthPoints = 0
            healthLabel.outlinedText = "HP: 0/\(scout.maxHealthPoints)"
            gameOver()
        }
    }
    
    func handleShotHit(shot: Shot, enemy: Enemy) {
        enemy.currentHealthPoints -= scout.damage
        if (enemy.currentHealthPoints <= 0) {
            enemy.currentHealthPoints = 0
            coins += enemy.getValue() * GameConstants.coinsMultiplier
            coinsLabel.outlinedText = "\(coins) COINS"
            score += enemy.getValue() * Int(Utils.vectorDistance(vectorA: enemy.node.position, vectorB: scout.node.position)) / GameConstants.scoreDivisor
            scoreLabel.outlinedText = "SCORE: \(score)"
            scoreLabel.text = "SCORE: \(score)"
            despawnEnemy(enemy: enemy)
            if livingEnemies.count == 0 {
                handleWaveEnd()
            }
        }
        despawnShot(shot: shot)
    }
    
    func despawnEnemy(enemy: Enemy) {
        enemy.node.removeFromParent()
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
        
        if !isGameOver {
            if let name = touchedNode.name {
                if name == "scout" {
                    print("User clicked scout")
                } else if name == "enemy"{
                    scout.updateRotation(touchPoint: touchPosition)
                    tryToFire()
                }
            } else {
                scout.updateRotation(touchPoint: touchPosition)
                tryToFire()
            }
        } else {
            if let name = touchedNode.name {
                if name == "gameOverBackLabel" || name == "gameWonBackLabel" {
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
        
        if !isGameOver {
            if let name = touchedNode.name {
                if name == "scout" {
                    fireTimer?.invalidate()
                } else if name == "enemy" {
                    scout.updateRotation(touchPoint: touchPosition)
                    tryToFire()
                }
            } else {
                scout.updateRotation(touchPoint: touchPosition)
                tryToFire()
            }
        } else {
            // Listen to game over overlay if needed
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
                    spawnNextWave()
                    hideUpgradeInterface()
                } else if name == "upgradeHeal" || name == "upgradeHealBuy" {
                    coins -= upgradeInterface!.buyUpgrade(upgradeIndex: UpgradeInterface.Upgrade.REPAIR, scout: scout, coins: coins)
                    updateLabels()
                    upgradeInterface!.updateLabels(scout: scout, score: score, coins: coins, wave: waveCount)
                } else if name == "upgradePistol" || name == "upgradePistolBuy" {
                    coins -= upgradeInterface!.buyUpgrade(upgradeIndex: UpgradeInterface.Upgrade.PISTOL, scout: scout, coins: coins)
                    updateLabels()
                    upgradeInterface!.updateLabels(scout: scout, score: score, coins: coins, wave: waveCount)
                } else if name == "upgradeLasergun" || name == "upgradeLasergunBuy" {
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
        gameWonLabel.text = "YOU SURVIVED"
        gameWonLabel.fontColor = SKColor.white
        gameWonLabel.zPosition = 1001
        gameWonLabel.fontSize = size.height / 5
        gameWonLabel.position = CGPoint(x: size.width / 2, y: (size.height / 3) * 2)
        
        let gameWonScoreLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
        gameWonScoreLabel.name = "gameWonScoreLabel"
        gameWonScoreLabel.text = "SCORE \(score)"
        gameWonScoreLabel.fontColor = SKColor.white
        gameWonScoreLabel.zPosition = 1001
        gameWonScoreLabel.fontSize = size.height / 10
        gameWonScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let gameWonBackLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
        gameWonBackLabel.name = "gameWonBackLabel"
        gameWonBackLabel.text = "BACK"
        gameWonBackLabel.fontColor = SKColor.white
        gameWonBackLabel.zPosition = 1001
        gameWonBackLabel.fontSize = size.height / 10
        gameWonBackLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) - (gameWonScoreLabel.frame.size.height * 4))
        
        addChild(backdrop)
        addChild(gameWonLabel)
        addChild(gameWonScoreLabel)
        addChild(gameWonBackLabel)
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
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.fontColor = SKColor.white
            gameOverLabel.zPosition = 1001
            gameOverLabel.fontSize = size.height / 5
            gameOverLabel.position = CGPoint(x: size.width / 2, y: (size.height / 3) * 2)
        
            let gameOverScoreLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
            gameOverScoreLabel.name = "gameOverScoreLabel"
            gameOverScoreLabel.text = "SCORE \(score)"
            gameOverScoreLabel.fontColor = SKColor.white
            gameOverScoreLabel.zPosition = 1001
            gameOverScoreLabel.fontSize = size.height / 10
            gameOverScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
            let gameOverWaveLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
            gameOverWaveLabel.name = "gameOverWaveLabel"
            gameOverWaveLabel.text = "WAVE \(waveCount)"
            gameOverWaveLabel.fontColor = SKColor.white
            gameOverWaveLabel.zPosition = 1001
            gameOverWaveLabel.fontSize = size.height / 10
            gameOverWaveLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) - (gameOverScoreLabel.frame.size.height * 1.5))
            
            let gameOverBackLabel = SKLabelNode(fontNamed: "8-Bit-Madness")
            gameOverBackLabel.name = "gameOverBackLabel"
            gameOverBackLabel.text = "BACK"
            gameOverBackLabel.fontColor = SKColor.white
            gameOverBackLabel.zPosition = 1001
            gameOverBackLabel.fontSize = size.height / 10
            gameOverBackLabel.position = CGPoint(x: size.width / 2, y: (size.height / 2) - (gameOverScoreLabel.frame.size.height * 4))
            
            addChild(backdrop)
            addChild(gameOverLabel)
            addChild(gameOverScoreLabel)
            addChild(gameOverWaveLabel)
            addChild(gameOverBackLabel)
        }
    }
    
    func initLabels() {
        // Health label
        healthLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        healthLabel.borderColor = UIColor.black
        healthLabel.borderWidth = healthLabel.fontSize / 4.5
        healthLabel.outlinedText = "HP: \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
        
        healthLabel.name = "healthLabel"
        healthLabel.fontColor = SKColor.white
        healthLabel.zPosition = 15
        healthLabel.position = CGPoint(x: size.width * 0.25, y: self.size.height / 100)
        
        // Score label
        scoreLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        scoreLabel.borderColor = UIColor.black
        scoreLabel.borderWidth = scoreLabel.fontSize / 4.5
        scoreLabel.outlinedText = "Score: \(score)"
        
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 15
        scoreLabel.position = CGPoint(x: size.width * 0.75, y: self.size.height / 100)
        
        // Wave label
        waveLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        waveLabel.borderColor = UIColor.black
        waveLabel.borderWidth = waveLabel.fontSize / 4.5
        waveLabel.outlinedText = "WAVE \(score)"
        waveLabel.name = "waveLabel"
        waveLabel.fontColor = SKColor.white
        waveLabel.fontSize = self.size.height / 25
        waveLabel.zPosition = 15
        waveLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.99 - waveLabel.frame.size.height)
        
        // Coins label
        coinsLabel = SKOutlinedLabelNode(fontNamed: "8-Bit-Madness", fontSize: self.size.height / 25)
        
        coinsLabel.borderColor = UIColor.black
        coinsLabel.borderWidth = coinsLabel.fontSize / 4.5
        coinsLabel.outlinedText = "\(coins) COINS"
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
        let newShot = Shot(size: self.size, scoutPosition: scout.node.position, direction: scout.calculateDirectionOfShot(size: self.size, touchPoint: touchPoint))
        
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
        
        addChild(background)
    }
    
}
