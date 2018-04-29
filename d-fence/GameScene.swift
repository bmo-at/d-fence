//
//  GameScene.swift
//  d-fence
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let despawnBound:CGFloat = 32 // points
    let background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var scout: Scout!
    var healthLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    var waveLabel: SKLabelNode!
    
    var shots = [Shot]()
    var touchPosition: CGPoint!
    var fireCooldown: TimeInterval = GameConstants.stoneCooldown
    var fireTimestamp: Date?
    var fireTimer: Timer?
    
    var livingEnemies = [Enemy]()
    var waveCount: Int = 0
    var coins: Int = 0
    var score: Int = 0
    
    func startNewGame() {
        initScout()
        initLabels()
        Enemy.initWaves(height: size.height, width: size.width)
        spawnNextWave()
    }
    
    func spawnNextWave() {
        waveCount += 1
        print("Spawning wave \(waveCount)...")
        
        livingEnemies = Enemy.getWave(wave: waveCount)
        
        for enemy in livingEnemies {
            addChild(enemy.node)
        }
    }
    
    override func didMove(to view: SKView) {
        // replace with init background when assets are ready
        // initBackground()
        backgroundColor = UIColor.green
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
        updateLabels()
    }
    
    func updateLabels() {
        waveLabel.text = "WAVE \(waveCount)"
        coinsLabel.text = "\(coins) COINS"
        scoreLabel.text = "SCORE: \(score)"
        healthLabel.text = "HP: \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
    }
    
    func updateEnemies() {
        for enemy in livingEnemies {
            let node = enemy.node
            
            let differenceToScout = CGPoint(x: scout.node.position.x - node.position.x, y: scout.node.position.y - node.position.y)
            
            if Utils.vectorAbs(vector: differenceToScout) > ((scout.node.size.width / 3) * 2) {
                node.position = CGPoint(x: node.position.x + (enemy.direction.x * CGFloat(dt)), y: node.position.y + (enemy.direction.y * CGFloat(dt)))
            } else {
                if !enemy.eating {
                    enemy.startEating(eat: handleBite)
                }
            }
        }
    }
    
    func handleWaveEnd() {
        // TODO: Show menu for upgrade etc.
        if (Enemy.getWave(wave: waveCount+1).isEmpty) {
            print("We don't have any more waves...")
            gameWon()
        } else {
            spawnNextWave()
        }
    }
    
    func handleBite(enemy: Enemy) {
        scout.currentHealthPoints -= enemy.damage
        if scout.currentHealthPoints <= 0 {
            scout.currentHealthPoints = 0
            scoreLabel.text = "HP: 0/\(scout.maxHealthPoints)"
            gameOver()
        }
    }
    
    func handleShotHit(shot: Shot, enemy: Enemy) {
        enemy.currentHealthPoints -= scout.damage
        if (enemy.currentHealthPoints <= 0) {
            enemy.currentHealthPoints = 0
            coins += enemy.getValue() * GameConstants.pointsMultiplier
            score += enemy.getValue() * Int(Utils.vectorDistance(vectorA: enemy.node.position, vectorB: scout.node.position)) / GameConstants.scoreDivisor
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
        
        if scout.currentHealthPoints > 0 {
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
            // TODO: Listen to game over overlay
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        
        if scout.currentHealthPoints > 0 {
            if let name = touchedNode.name {
                if name == "scout" {
                    print("User is moving finger over scout")
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
            // TODO: Listen to game over overlay
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTimer?.invalidate()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTimer?.invalidate()
    }
    
    func tryToFire() {
        let sinceLastFiringAttempt = Date().timeIntervalSince(fireTimestamp ?? Date(timeIntervalSince1970: 0));
        
        if (sinceLastFiringAttempt > fireCooldown) {
            if let fT = fireTimer {
                fT.invalidate()
            }
            fireTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(fireCooldown), repeats: true) { (timer) in
                self.tryToFire();
            }
            fireTimestamp = Date()
            initShot(touchPoint: touchPosition)
        }
    }
    
    func gameWon() {
        let backdrop = SKShapeNode(rectOf: CGSize(width: size.width * 6, height: size.height * 6))
        backdrop.name = "gameWonBackdrop"
        backdrop.fillColor = SKColor.black
        backdrop.position = CGPoint.zero
        backdrop.alpha = 0.8
        backdrop.zPosition = 1000
        
        let gameWonLabel = SKLabelNode(fontNamed: "October Crow")
        gameWonLabel.name = "gameWonLabel"
        gameWonLabel.text = "YOU WON!!!"
        gameWonLabel.fontColor = SKColor.white
        gameWonLabel.zPosition = 1001
        gameWonLabel.fontSize = size.height / 3
        gameWonLabel.position = CGPoint(x: size.width / 2, y: (size.height / 3) * 2)
        
        addChild(backdrop)
        addChild(gameWonLabel)
    }
    
    func gameOver() {
        for enemy in livingEnemies {
            enemy.stopEating()
        }
        
        let backdrop = SKShapeNode(rectOf: CGSize(width: size.width * 6, height: size.height * 6))
        backdrop.name = "gameOverBackdrop"
        backdrop.fillColor = SKColor.black
        backdrop.position = CGPoint.zero
        backdrop.alpha = 0.8
        backdrop.zPosition = 1000
        
        let gameOverLabel = SKLabelNode(fontNamed: "October Crow")
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.zPosition = 1001
        gameOverLabel.fontSize = size.height / 3
        gameOverLabel.position = CGPoint(x: size.width / 2, y: (size.height / 3) * 2)
        
        addChild(backdrop)
        addChild(gameOverLabel)
    }
    
    func initLabels() {
        // Health label
        healthLabel = SKLabelNode(fontNamed: "October Crow")
        healthLabel.text = "HP: \(scout.currentHealthPoints)/\(scout.maxHealthPoints)"
        healthLabel.name = "healthLabel"
        healthLabel.fontColor = SKColor.black
        healthLabel.fontSize = self.size.height / 25
        healthLabel.zPosition = 150
        healthLabel.position = CGPoint(x: healthLabel.frame.width / 2, y: self.size.height / 100)
        
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "October Crow")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontSize = self.size.height / 25
        scoreLabel.zPosition = 150
        scoreLabel.position = CGPoint(x: size.width / 2, y: self.size.height / 100)
        
        // Wave label
        waveLabel = SKLabelNode(fontNamed: "October Crow")
        waveLabel.text = "WAVE \(score)"
        waveLabel.name = "waveLabel"
        waveLabel.fontColor = SKColor.black
        waveLabel.fontSize = self.size.height / 25
        waveLabel.zPosition = 150
        waveLabel.position = CGPoint(x: size.width / 2, y: size.height - waveLabel.frame.size.height)
        
        // Coins label
        coinsLabel = SKLabelNode(fontNamed: "October Crow")
        coinsLabel.text = "\(coins) COINS"
        coinsLabel.name = "coinsLabel"
        coinsLabel.fontColor = SKColor.black
        coinsLabel.fontSize = self.size.height / 25
        coinsLabel.zPosition = 150
        coinsLabel.position = CGPoint(x: size.width - coinsLabel.frame.size.width, y: size.height - waveLabel.frame.size.height)
        
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
