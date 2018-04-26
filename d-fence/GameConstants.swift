//
//  GameConstants.swift
//  d-fence
//

import SpriteKit

class GameConstants {
    
    // treehouse
    static let treehouseHealthPoints: CGFloat = 200
    
    // projectiles
    static let stoneDamage: CGFloat = 10.0
    static let stoneVelocity: CGFloat = 0.5
    static let stoneCooldown: TimeInterval = 1.0
    
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
    
    // midEnemy
    static let midEnemyVelocity: CGFloat = 0.03
    static let midEnemyHealthPoints: CGFloat = 20
    static let midEnemyDamage: CGFloat = 20
    
    // highEnemy
    static let highEnemyVelocity: CGFloat = 0.03
    static let highEnemyHealthPoints: CGFloat = 20
    static let highEnemyDamage: CGFloat = 20
    
}
