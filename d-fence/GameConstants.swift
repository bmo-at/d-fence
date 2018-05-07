//
//  GameConstants.swift
//  d-fence
//

import SpriteKit

class GameConstants {
    
    // general
    static let scoreDivisor: Int = 9
    static let coinsMultiplier: Int = 56
    
    // treehouse
    static let treehouseHealthPoints: CGFloat = 400
    static let treehouseRepairCosts: Int = 600
    static let treehouseRepairValue: Int = 100
    
    // projectiles
    static let stoneDamage: CGFloat = 10.0
    static let stoneVelocity: CGFloat = 0.5
    static let stoneCooldown: TimeInterval = 0.76
    
    static let pistolDamage: CGFloat = 53.0
    static let pistolVelocity: CGFloat = 1.0
    static let pistolCooldown: TimeInterval = 0.5
    static let pistolCosts: Int = 4000
    
    static let laserDamage: CGFloat = 74.0
    static let laserVelocity: CGFloat = 3.0
    static let laserCooldown: TimeInterval = 0.98
    static let laserCosts: Int = 28500
    
    // lowEnemy
    static let lowEnemyVelocity: CGFloat = 0.03
    static let lowEnemyHealthPoints: CGFloat = 20
    static let lowEnemyDamage: CGFloat = 5
    static let lowEnemyEatingRate: TimeInterval = 1.0
    static let lowEnemyValue: Int = 2
    
    // midEnemy
    static let midEnemyVelocity: CGFloat = 0.014
    static let midEnemyHealthPoints: CGFloat = 200
    static let midEnemyDamage: CGFloat = 42
    static let midEnemyEatingRate: TimeInterval = 1.5
    static let midEnemyValue: Int = 9
    
    // highEnemy
    static let highEnemyVelocity: CGFloat = 0.05
    static let highEnemyHealthPoints: CGFloat = 55
    static let highEnemyDamage: CGFloat = 150
    static let highEnemyEatingRate: TimeInterval = 5.0
    static let highEnemyValue: Int = 19
    
}
