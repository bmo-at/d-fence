//
//  Enemy.swift
//  d-fence
//
//  Created by Hendrik Ulbrich on 24.04.18.
//  Copyright © 2018 zom. All rights reserved.
//

import SpriteKit

class Enemy {
    
    enum EnemyType {
        case low
        case mid
        case high
    }

    let lowEnemyVelocity: CGFloat = 0.03
    let lowEnemyHealthPoints: CGFloat = 50
    
    static func getWave(wave: Int) -> [String: Enemy] {
        return waves[wave-1]
    }
    
    static func initWaves(height: CGFloat, width: CGFloat) {
        /* TODO: Justify the horde constallations. Currently only a placeholder*/
        // Wave 1
        waves.append([:])
        var id = UUID().uuidString
        waves[0][UUID().uuidString] = Enemy(EnemyType.low, CGPoint(x: 0, y: 0), id, CGSize(width: width, height: height))
        id = UUID().uuidString
        waves[0][UUID().uuidString] = Enemy(EnemyType.low, CGPoint(x: width, y: 0), id, CGSize(width: width, height: height))
        id = UUID().uuidString
        waves[0][UUID().uuidString] = Enemy(EnemyType.low, CGPoint(x: 0, y: height), id, CGSize(width: width, height: height))
        id = UUID().uuidString
        waves[0][UUID().uuidString] = Enemy(EnemyType.low, CGPoint(x: width , y: height), id, CGSize(width: width, height: height))
        
        
        // Wave 2
        waves.append([:])
        id = UUID().uuidString
        waves[1][UUID().uuidString] = Enemy(EnemyType.low, CGPoint(x: width, y: height), id, CGSize(width: width, height: height))
    }
    
    fileprivate static var waves: [[String: Enemy]] = []
    
    let type: EnemyType
    let spriteNode: SKSpriteNode
    let direction: CGPoint
    var healthPoints: Double = 0
    
    required init(_ type: EnemyType,_ position: CGPoint, _ name: String, _ size: CGSize) {
        self.type = type
        
        
//        return Utils.vectorScale(vector: Utils.vectorNorm(vector: difference), scale: bulletVelocity * size.height)
        
        var typeString: String
        var velocity: CGFloat
        
        if type == EnemyType.low {
            velocity = lowEnemyVelocity
            typeString = "lowEnemy"
        } else if type == EnemyType.mid {
            velocity = lowEnemyVelocity
            typeString = "midEnemy"
        } else { // high
            velocity = lowEnemyVelocity
            typeString = "highEnemy"
        }
        
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let difference = CGPoint(x: center.x - position.x, y: center.y - position.y)
        self.direction = Utils.vectorScale(vector: Utils.vectorNorm(vector: difference), scale: velocity * size.height)
        
        spriteNode = SKSpriteNode(imageNamed: typeString)
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteNode.position = position
        spriteNode.zPosition = 5
        spriteNode.name = name
        spriteNode.scale(to: CGSize(width: size.height / 20, height: size.height / 20))
    }
}
