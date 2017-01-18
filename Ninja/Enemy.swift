//
//  Enemy.swift
//  Ninja
//
//  Created by Chris Pelling on 16/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    
    var textures = [SKTexture]()
    let textureName:String
    var squashTextures = [SKTexture]()
    
    let bounceSound = SKAction.playSoundFileNamed("bounce", waitForCompletion: false)
    let whackSound = SKAction.playSoundFileNamed("splat.wav", waitForCompletion: false)

    init(withTextureName:String)
    {
        textureName = withTextureName
        
        for i in 1...3 {
            let texture = SKTexture(imageNamed: "\(textureName)\(i)")
            textures.append(texture)
        }
        
        for i in 1...5 {
            let squashTexture = SKTexture(imageNamed: "\(textureName)_squash_\(i)")
            squashTextures.append(squashTexture)
        }
        
        
        super.init(texture: textures[0], color:UIColor.clearColor(), size: textures[0].size())
        
        self.name = "enemy"
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            //self.setScale(CGFloat.random(min: 0.4, max: 0.75))
            //self.scaleAsPoint = CGPoint(x: 10, y: 10)
        }
        
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
        let blinkAction = SKAction.repeatActionForever(SKAction.afterDelay(Double(CGFloat.random(min: 1, max: 2)), performAction: SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize:false, restore:true)))
        self.runAction(blinkAction, withKey: "blink")
    }
    
    func bounce()
    {
        self.runAction(self.bounceSound)
    }
    
    func squash()
    {
        self.removeActionForKey("blink")
        self.runAction(whackSound)
        let squashAnimation = SKAction.animateWithTextures(squashTextures, timePerFrame: 0.004, resize: true, restore: false)
        self.physicsBody?.angularVelocity = 0.0
        self.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsBody?.affectedByGravity = false
        let reduce = SKAction.fadeAlphaTo(0.0, duration: 0.004)
        self.runAction(SKAction.sequence([squashAnimation, reduce])) {
            self.removeFromParent()
        }
    }
    
    func clone() -> Enemy
    {
        let enemy = Enemy(withTextureName: self.textureName)
        enemy.scaleAsPoint = self.scaleAsPoint
        return enemy
    }
    
}
