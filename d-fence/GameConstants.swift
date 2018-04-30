//
//  GameConstants.swift
//  d-fence
//

import SpriteKit

class GameConstants {
    
    // general
    static let scoreDivisor: Int = 10
    static let pointsMultiplier: Int = 12
    
    // treehouse
    static let treehouseHealthPoints: CGFloat = 200
    
    // projectiles
    static let stoneDamage: CGFloat = 10.0
    static let stoneVelocity: CGFloat = 0.5
    static let stoneCooldown: TimeInterval = 0.1
    
    static let cartridgeDamage: CGFloat = 50.0
    static let cartridgeVelocity: CGFloat = 0.25
    static let cartridgeCooldown: TimeInterval = 0.5
    
    static let laserDamage: CGFloat = 400.0
    static let laserVelocity: CGFloat = 0.1
    static let laserCooldown: TimeInterval = 0.1
    
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
