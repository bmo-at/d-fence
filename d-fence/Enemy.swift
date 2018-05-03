//
//  Enemy.swift
//  d-fence
//

import SpriteKit

class Enemy: Hashable {
    
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return node.hashValue
    }

    enum EnemyType {
        case low
        case mid
        case high
    }
    
    static func getWave(wave: Int) -> [Enemy] {
        if wave > waves.count {
            return []
        }
        return waves[wave-1]
    }
    
    static func initWaves(height: CGFloat, width: CGFloat) {
        Enemy.buildZombieFrames()
        
        waves = []
        
        /* TODO: Justify the horde constallations. Currently only a placeholder*/
        // Wave 1
        waves.append([])
        waves[0].append(Enemy(EnemyType.low, CGPoint(x: 0, y: 0), CGSize(width: width, height: height)))
        waves[0].append(Enemy(EnemyType.low, CGPoint(x: width, y: 0), CGSize(width: width, height: height)))
        waves[0].append(Enemy(EnemyType.low, CGPoint(x: 0, y: height), CGSize(width: width, height: height)))
        waves[0].append(Enemy(EnemyType.low, CGPoint(x: width , y: height), CGSize(width: width, height: height)))
        
        // Wave 2
        waves.append([])
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: 0, y: 0), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: 0), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: width / 2, y: 0), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: 0), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: width, y: 0), CGSize(width: width, height: height)))
        
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: 0, y: height), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: height), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: width / 2, y: height), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: height), CGSize(width: width, height: height)))
        waves[1].append(Enemy(EnemyType.low, CGPoint(x: width, y: height), CGSize(width: width, height: height)))
        
        // Wave 3
        waves.append([])
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: 0, y: 0), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: 0), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 2, y: 0), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: 0), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width, y: 0), CGSize(width: width, height: height)))
        
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: 0, y: height), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: height), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 2, y: height), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: height), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width, y: height), CGSize(width: width, height: height)))
        
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: 0, y: -20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: -20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 2, y: -20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: -20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width, y: -20), CGSize(width: width, height: height)))
        
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: 0, y: height + 20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: height + 20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width / 2, y: height + 20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: height + 20), CGSize(width: width, height: height)))
        waves[2].append(Enemy(EnemyType.low, CGPoint(x: width, y: height + 20), CGSize(width: width, height: height)))
        
        // Wave 4
        waves.append([])
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: 0, y: 0), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.mid, CGPoint(x: width / 4, y: 0), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.mid, CGPoint(x: width / 2, y: 0), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: 0), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: width, y: 0), CGSize(width: width, height: height)))
    
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: 0, y: height), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: height), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.mid, CGPoint(x: width / 2, y: height), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.mid, CGPoint(x: (width / 4) * 3, y: height), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: width, y: height), CGSize(width: width, height: height)))
        
        waves[3].append(Enemy(EnemyType.mid, CGPoint(x: 0, y: -20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: -20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: width / 2, y: -20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: -20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.mid, CGPoint(x: width, y: -20), CGSize(width: width, height: height)))
        
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: 0, y: height + 20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: width / 4, y: height + 20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.mid, CGPoint(x: width / 2, y: height + 20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: (width / 4) * 3, y: height + 20), CGSize(width: width, height: height)))
        waves[3].append(Enemy(EnemyType.low, CGPoint(x: width, y: height + 20), CGSize(width: width, height: height)))
    }
    
    fileprivate static func buildZombieFrames() {
        let lowZombieAnimatedAtlas = SKTextureAtlas(named: "lowZombieImages")
        let midZombieAnimatedAtlas = SKTextureAtlas(named: "midZombieImages")
        let highZombieAnimatedAtlas = SKTextureAtlas(named: "highZombieImages")
        
        for i in 0...lowZombieAnimatedAtlas.textureNames.count-1 {
            lowZombieWalkFrames.append(lowZombieAnimatedAtlas.textureNamed("lowZombie\(i)"))
            midZombieWalkFrames.append(midZombieAnimatedAtlas.textureNamed("midZombie\(i)"))
            highZombieWalkFrames.append(highZombieAnimatedAtlas.textureNamed("highZombie\(i)"))
        }
    }
    
    fileprivate static var waves: [[Enemy]] = []
    fileprivate static var lowZombieWalkFrames: [SKTexture] = []
    fileprivate static var midZombieWalkFrames: [SKTexture] = []
    fileprivate static var highZombieWalkFrames: [SKTexture] = []
    
    let type: EnemyType
    let node: SKSpriteNode
    let direction: CGPoint
    let damage: CGFloat
    let frames: [SKTexture]
    var eatingRate: TimeInterval
    var currentHealthPoints: CGFloat = 0
    var maxHealthPoints: CGFloat = 0
    var eating: Bool = false
    var eatingTimer: Timer?
    var hasScreamed: Bool = false
    
    func getValue() -> Int {
        if type == EnemyType.low {
            return GameConstants.lowEnemyValue
        } else if type == EnemyType.mid {
            return GameConstants.midEnemyValue
        } else {
            return GameConstants.highEnemyValue
        }
    }
    
    func startEating(eat: @escaping (Enemy) -> ()) {
        eating = true
        eatingTimer = Timer.scheduledTimer(withTimeInterval: eatingRate, repeats: true) { (timer) in
            eat(self)
        }
        eat(self)
    }
    
    func stopEating() {
        eatingTimer?.invalidate()
    }
    
    required init(_ type: EnemyType, _ position: CGPoint, _ size: CGSize) {
        self.type = type

        var velocity: CGFloat
        
        if type == EnemyType.low {
            velocity = GameConstants.lowEnemyVelocity
            frames = Enemy.lowZombieWalkFrames
            currentHealthPoints = GameConstants.lowEnemyHealthPoints
            maxHealthPoints = GameConstants.lowEnemyHealthPoints
            eatingRate = GameConstants.lowEnemyEatingRate
            damage = GameConstants.lowEnemyDamage
        } else if type == EnemyType.mid {
            velocity = GameConstants.midEnemyVelocity
            frames = Enemy.midZombieWalkFrames
            currentHealthPoints = GameConstants.midEnemyHealthPoints
            maxHealthPoints = GameConstants.midEnemyHealthPoints
            eatingRate = GameConstants.midEnemyEatingRate
            damage = GameConstants.midEnemyDamage
        } else { // high
            velocity = GameConstants.highEnemyVelocity
            frames = Enemy.highZombieWalkFrames
            currentHealthPoints = GameConstants.highEnemyHealthPoints
            maxHealthPoints = GameConstants.highEnemyHealthPoints
            eatingRate = GameConstants.highEnemyEatingRate
            damage = GameConstants.highEnemyDamage
        }
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let difference = CGPoint(x: center.x - position.x, y: center.y - position.y)
        direction = Utils.vectorScale(vector: Utils.vectorNorm(vector: difference), scale: velocity * size.height)
        
        node = SKSpriteNode(texture: frames[0])
        node.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "walking")
        
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        node.position = position
        node.zPosition = 5
        node.zRotation = Utils.vectorAngular(vectorA: CGPoint(x: 1, y: 0), vectorB: direction)
        node.name = "enemy"
        node.scale(to: CGSize(width: size.height / 15, height: size.height / 15))
    }
}
