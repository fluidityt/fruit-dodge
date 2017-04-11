 //
//  Enemy.swift
//  Ninja
//
//  Created by Chris Pelling on 16/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import SpriteKit

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

class Enemy: SKSpriteNode {
    
    var textures = [SKTexture]()
    let textureName:String
    var squashTextures = [SKTexture]()
    
    static let bounceSound = SKAction.playSoundFileNamed("bounce", waitForCompletion: false)
    static let whackSound = SKAction.playSoundFileNamed("splat.wav", waitForCompletion: false)

    init(withTextureName:String)
    {
        textureName = withTextureName
        
        for i in 1...1 {
            let texture = SKTexture(imageNamed: "\(textureName)\(i)")
            textures.append(texture)
        }
        
        for i in 1...5 {
            let squashTexture = SKTexture(imageNamed: "\(textureName)_squash_\(i)")
            squashTextures.append(squashTexture)
        }
        
        super.init(texture: textures[0], color:UIColor.clear, size: textures[0].size())
        
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
    
    func squash()
    {
        self.removeAction(forKey: "blink")
        self.run(Enemy.whackSound)
        let squashAnimation = SKAction.animate(with: squashTextures, timePerFrame: 0.032, resize: true, restore: false)
        self.physicsBody?.angularVelocity = 0.0
        self.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsBody?.affectedByGravity = false
        let reduce = SKAction.fadeAlpha(to: 0.0, duration: 0.004)
        self.run(SKAction.sequence([squashAnimation, reduce]), completion: {
            self.removeFromParent()
        }) 
    }
    
    func clone() -> Enemy
    {
        let enemy = Enemy(withTextureName: self.textureName)
        enemy.scaleAsPoint = self.scaleAsPoint
        return enemy
    }
    
}
