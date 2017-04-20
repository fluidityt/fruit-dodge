 //
//  Enemy.swift
//  Ninja
//
//  Created by Chris Pelling on 16/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

struct TextureLoader {
    
    private static var atlases:[SKTextureAtlas]?
    
    static func preloadTextures()
    {
        if atlases == nil {
            atlases = [SKTextureAtlas(named: "fruit"), SKTextureAtlas(named: "resized"), SKTextureAtlas(named: "icons")]
            SKTextureAtlas.preloadTextureAtlases(atlases!, withCompletionHandler: {
                print("Preloaded textures")
            })
        }
    }
    
    static func outputAtlases()
    {
        for atlas in atlases! {
            for name in atlas.textureNames {
                print(name)
            }
        }
    }
}
 
enum EnemyDirection {
        case Left,
        Right
}

class Enemy: SKSpriteNode {
    
    var textures = [SKTexture]()
    let textureName:String
    var stateMachine:EnemyStateMachine!
    
    static let bounceSound = SKAction.playSoundFileNamed("bounce", waitForCompletion: false)
    static let whackSound = SKAction.playSoundFileNamed("splat.wav", waitForCompletion: false)

    init(withTextureName:String)
    {
        textureName = withTextureName
        
        
        let texture = SKTexture(imageNamed: "\(textureName)\(1)")

        super.init(texture: texture, color:UIColor.clear, size: texture.size())
        
        stateMachine = EnemyStateMachine(enemy: self)
        
        self.name = "enemy"
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        
        self.physicsBody?.restitution = 0.985
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.categoryBitMask = PhysicsCategories.enemy.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategories.topwall.rawValue
        
        //blink()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func blink()
    {
        //let blinkAction = SKAction.repeatActionForever(SKAction.afterDelay(Double(CGFloat.random(min: 1, max: 2)), performAction: SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize:false, restore:true)))
        //self.runAction(blinkAction, withKey: "blink")
    }
    
    func bounce()
    {
        self.run(Enemy.bounceSound)
    }
    
    func clone() -> Enemy
    {
        let enemy = Enemy(withTextureName: self.textureName)
        enemy.scaleAsPoint = self.scaleAsPoint
        return enemy
    }
    
    deinit {
        print("Killing \(textureName)")
    }
}
 
 
 class EnemyStateMachine:GKStateMachine
 {
    weak var enemy:Enemy?
    
    init(enemy:Enemy) {
        
        self.enemy = enemy
        
        var states = [GKState]()
        
        states = [BouncingRight(), BouncingLeft(), Squashed()]
        super.init(states: states)
    }
 }
 
 class EnemyState:GKState {
    var node:Enemy {
        get {
            let state = self.stateMachine as! EnemyStateMachine
            return state.enemy!
        }
    }
 }
 
 class BouncingRight:EnemyState
 {
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if node.position.x - node.size.width/2 > node.scene!.size.width {
            node.removeFromParent()
        }
        
        node.physicsBody?.angularVelocity = -7.0
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is BouncingLeft.Type:
            return false
        default:
            return true
        }
    }
 }
 
 class BouncingLeft:EnemyState
 {
    override func didEnter(from previousState: GKState?) {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if node.position.x - node.size.width/2 < 0.0 {
            node.removeFromParent()
        }
        
        node.physicsBody?.angularVelocity = 7.0
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is BouncingRight.Type:
            return false
        default:
            return true
        }
    }
 }
 
 class Squashed:EnemyState
 {
    override func didEnter(from previousState: GKState?) {
        var squashTextures:[SKTexture] = [SKTexture]()
        
        for i in 1...5 {
            let squashTexture = SKTexture(imageNamed: "\(node.textureName)_squash_\(i)")
            squashTextures.append(squashTexture)
        }
        
        node.removeAction(forKey: "blink")
        node.run(Enemy.whackSound)
        let squashAnimation = SKAction.animate(with: squashTextures, timePerFrame: 0.032, resize: true, restore: false)
        node.physicsBody?.angularVelocity = 0.0
        node.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        node.physicsBody?.affectedByGravity = false
        let reduce = SKAction.fadeAlpha(to: 0.0, duration: 0.004)
        node.run(SKAction.sequence([squashAnimation, reduce]), completion: {
            self.node.removeFromParent()
        })
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
 }
