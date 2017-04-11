//
//  Player.swift
//  Ninja
//
//  Created by Chris Pelling on 21/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Player: SKSpriteNode {
    
    var state:PlayerState!
    var idleTextures = [SKTexture]()
    var runTextures = [SKTexture]()
    var defeatedTextures = [SKTexture]()
    var hitTextures = [SKTexture]()
    var runSpeed:CGFloat = 500
    var lives = 3
    var invincibleTimer:TimeInterval = 0.0
    
    var moving:Bool {
        return self.physicsBody?.velocity.dx > 0
    }
    
    var invincible:Bool {
        guard let bitMask = self.physicsBody?.contactTestBitMask else {
            return false
        }
        return bitMask & PhysicsCategories.enemy.rawValue == 0
    }
   
    
    init() {
        
        super.init(texture: SKTexture(imageNamed: "idle_0"), color: UIColor.clear, size: CGSize(width: 166, height: 221))
        loadTextures()
        
        
        state = PlayerState(player:self)
        
        // Scale down physics body size so it isn't larger than the actual player.
        let physicsBodySize = CGSize(width: self.texture!.size().width*0.9, height: self.texture!.size().height)
 
        self.physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize)
        
        
        self.physicsBody = SKPhysicsBody(texture: idleTextures[0], size: idleTextures[0].size())
        self.physicsBody?.categoryBitMask = PhysicsCategories.character.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.sidewall.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategories.sidewall.rawValue | PhysicsCategories.powerup.rawValue
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        
    }
    
    internal func loadTextures()
    {
        for i in 0...7 {
            let texture = SKTexture(imageNamed: "run_\(i)")
            runTextures.append(texture)
        }
        
        for i in 0...11 {
            let texture = SKTexture(imageNamed: "idle_\(i)")
            idleTextures.append(texture)
        }
        
        for i in 0...11 {
            let texture = SKTexture(imageNamed: "die_\(i)")
            defeatedTextures.append(texture)
        }
        
        for i in 0...2 {
            let texture = SKTexture(imageNamed: "hurt_\(i)")
            hitTextures.append(texture)
        }
    }
    
    func enterState(_ state:GKState) {
        //self.state.enterState()
    }
    
    func kill()
    {
        self.lives = 0
        self.state.enter(Defeated.self)
    }
    
    func decreaseLives()
    {
        self.lives -= 1
    }
    
    func makeInvincible(_ forDuration:TimeInterval)
    {
        self.invincibleTimer = forDuration
        self.blendMode = .add
        self.color = SKColor.red
        self.physicsBody?.contactTestBitMask = PhysicsCategories.sidewall.rawValue | PhysicsCategories.powerup.rawValue
    }
    
    func makeVincible()
    {
        self.invincibleTimer = 0.0
        self.blendMode = .alpha
        self.physicsBody?.contactTestBitMask = PhysicsCategories.enemy.rawValue | PhysicsCategories.sidewall.rawValue | PhysicsCategories.powerup.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

