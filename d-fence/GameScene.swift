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
    
    var shots = [Shot]()
    var touchPosition: CGPoint!
    var fireCooldown: TimeInterval = GameConstants.stoneCooldown
    var fireTimestamp: Date?
    var fireTimer: Timer!
    
    var livingEnemies = [Enemy]()
    var waveCount: Int = 0
    var points: Int = 0
    
    // = = = = = = = = = = = = = = = = = = = = = = =
    
    func startNewGame() {
        initScout()
        Enemy.initWaves(height: size.height, width: size.width)
        spawnNextWave()
    }
    
    func spawnNextWave() {
        waveCount += 1
        print("Spawning wave \(waveCount)...")
        
        livingEnemies = Enemy.getWave(wave: waveCount)
        
        print(livingEnemies)
        
        for enemy in livingEnemies {
            enemy.node.zPosition = 10
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
    }
    
    func updateEnemies() {
        for enemy in livingEnemies {
            let node = enemy.node
            
            let differenceToScout = CGPoint(x: scout.node.position.x - node.position.x, y: scout.node.position.y - node.position.y)
            
            if Utils.vectorAbs(vector: differenceToScout) > (scout.node.size.width / 2) {
                node.position = CGPoint(x: node.position.x + (enemy.direction.x * CGFloat(dt)), y: node.position.y + (enemy.direction.y * CGFloat(dt)))
            }
        }
    }
    
    func handleShotHit(shot: Shot, enemy: Enemy) {
        enemy.currentHealthPoints -= scout.damage
        if (enemy.currentHealthPoints < 0) {
            // TODO: Add points
            despawnEnemy(enemy: enemy)
        }
        despawnShot(shot: shot)
    }
    
    func despawnEnemy(enemy: Enemy) {
        enemy.node.removeFromParent()
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
        
        if let name = touchedNode.name {
            if name == "scout" {
                print("User clicked scout")
            } else { // enemy
                scout.updateRotation(touchPoint: touchPosition)
                tryToFire()
            }
        } else {
            scout.updateRotation(touchPoint: touchPosition)
            tryToFire()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        
        if let name = touchedNode.name {
            if name == "scout" {
                print("User is moving finger over scout")
            } else {
                scout.updateRotation(touchPoint: touchPosition)
                tryToFire()
            }
        } else {
            scout.updateRotation(touchPoint: touchPosition)
            tryToFire()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTimer.invalidate()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTimer.invalidate()
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
    
    func initShot(touchPoint: CGPoint) {
        let newShot = Shot(size: self.size, scoutPosition: scout.node.position, direction: scout.calculateDirectionOfShot(size: self.size, touchPoint: touchPoint))
        
        shots.append(newShot)
        
        addChild(newShot.node)
    }
    
    func initScout() {
        scout = Scout(size: self.size)
        
        addChild(scout.node)
    }

    
    func initBackground() {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        
        addChild(background)
    }
    
}
