//
//  GameConstants.swift
//  d-fence
//

import SpriteKit

class GameConstants {
    
    // general
    static let scoreDivisor: Int = 10
    static let coinsMultiplier: Int = 550
    
    // treehouse
    static let treehouseHealthPoints: CGFloat = 200
    static let treehouseRepairCosts: Int = 200
    static let treehouseRepairValue: Int = 100
    
    // projectiles
    static let stoneDamage: CGFloat = 10.0
    static let stoneVelocity: CGFloat = 0.5
    static let stoneCooldown: TimeInterval = 0.2
    
    static let pistolDamage: CGFloat = 50.0
    static let pistolVelocity: CGFloat = 1.0
    static let pistolCooldown: TimeInterval = 0.5
    static let pistolCosts: Int = 1000
    
    static let laserDamage: CGFloat = 400.0
    static let laserVelocity: CGFloat = 3.0
    static let laserCooldown: TimeInterval = 0.1
    static let laserCosts: Int = 10000
    
    // lowEnemy
    static let lowEnemyVelocity: CGFloat = 0.03
    static let lowEnemyHealthPoints: CGFloat = 20
    static let lowEnemyDamage: CGFloat = 20
    static let lowEnemyEatingRate: TimeInterval = 2.0
    static let lowEnemyValue: Int = 2
    
    // midEnemy
    static let midEnemyVelocity: CGFloat = 0.03
    static let midEnemyHealthPoints: CGFloat = 90
    static let midEnemyDamage: CGFloat = 50
    static let midEnemyEatingRate: TimeInterval = 1.4
    static let midEnemyValue: Int = 8
    
    // highEnemy
    static let highEnemyVelocity: CGFloat = 0.02
    static let highEnemyHealthPoints: CGFloat = 45
    static let highEnemyDamage: CGFloat = 200
    static let highEnemyEatingRate: TimeInterval = 5.0
    static let highEnemyValue: Int = 19
    
}
