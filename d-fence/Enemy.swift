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

    static let lowEnemySpeed = 100
    static let lowEnemyHealthPoints = 50
    
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
    var healthPoints: Double = 0
    
    required init(_ type: EnemyType,_ position: CGPoint, _ name: String, _ size: CGSize) {
        self.type = type
        var typeString: String
        
        if type == EnemyType.low {
            typeString = "lowEnemy"
        } else if type == EnemyType.mid {
            typeString = "midEnemy"
        } else { // high
            typeString = "highEnemy"
        }
        
        spriteNode = SKSpriteNode(imageNamed: typeString)
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteNode.position = position
        spriteNode.zPosition = 5
        spriteNode.name = name
        spriteNode.scale(to: CGSize(width: size.height / 20, height: size.height / 20))
    }
}