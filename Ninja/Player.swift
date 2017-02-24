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

class Player: SKSpriteNode {
    
    var state:PlayerState!
    var idleTextures = [SKTexture]()
    var runTextures = [SKTexture]()
    var defeatedTexture = SKTexture(imageNamed: "monkey_dead")
    var runSpeed:CGFloat = 500
    
    var moving:Bool {
        return self.physicsBody?.velocity.dx > 0
    }
   
    var cropNode = SKCropNode();
    var maskNode:SKSpriteNode
    
    init() {
        
        maskNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 246, height: 295))

        super.init(texture: SKTexture(imageNamed: "idle_0"), color: UIColor.clearColor(), size: CGSize(width: 246, height: 295))
        loadTextures()
        
        
        state = PlayerState(player:self)
        
        // Scale down physics body size so it isn't larger than the actual player.
        let physicsBodySize = CGSize(width: idleTextures[0].size().width*0.9, height: idleTextures[0].size().height)
        print(physicsBodySize)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: physicsBodySize)
        
        
        self.physicsBody = SKPhysicsBody(texture: idleTextures[0], size: idleTextures[0].size())
        self.physicsBody?.categoryBitMask = PhysicsCategories.character.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.sidewall.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategories.enemy.rawValue | PhysicsCategories.sidewall.rawValue | PhysicsCategories.powerup.rawValue
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        
        
        cropNode.maskNode = maskNode
        cropNode.addChild(SKSpriteNode(texture: defeatedTexture, size: size))
        addChild(cropNode)
        cropNode.hidden = true
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
    }
    
    func enterState(state:GKState) {
        //self.state.enterState()
    }
    
    func kill()
    {
        self.state.enterState(Defeated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

