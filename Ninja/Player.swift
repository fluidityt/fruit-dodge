//
//  Player.swift
//  Ninja
//
//  Created by Chris Pelling on 21/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {
    
    var state:PlayerState!
    let idleTexture = SKTexture(imageNamed: "monkey_run_1")
    var runTextures = [SKTexture]()
    var defeatedTexture = SKTexture(imageNamed: "monkey_dead")
    var runSpeed:CGFloat {
        guard let view = scene?.view else {
            return UIScreen.mainScreen().bounds.width / 3.0
        }
        
        print(view.frame.width/3.0)
        return view.frame.width / 3.1459
    }
    
    var moving:Bool {
        return self.physicsBody?.velocity.dx > 0
    }
    
    var cropNode = SKCropNode();
    var maskNode:SKSpriteNode
    
    init() {
        let ratio = idleTexture.size().height / idleTexture.size().width
        let height = UIScreen.mainScreen().bounds.height/7
        
        let textureSize = CGSize(width: height/ratio, height: height)
        maskNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: textureSize.width, height: textureSize.height))

        super.init(texture: idleTexture, color: UIColor.clearColor(), size: textureSize)
        
        loadRunTextures()
        
        state = PlayerState(player:self)
        
        // Scale down physics body size so it isn't larger than the actual player.
        let physicsBodySize = CGSize(width: textureSize.width*0.7, height: textureSize.height*0.9)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: physicsBodySize)
        self.physicsBody?.categoryBitMask = PhysicsCategories.character.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.sidewall.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategories.enemy.rawValue | PhysicsCategories.sidewall.rawValue
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.linearDamping = 0.0
        
        
        cropNode.maskNode = maskNode
        cropNode.addChild(SKSpriteNode(texture: defeatedTexture, size: size))
        addChild(cropNode)
        cropNode.hidden = true
    }
    
    internal func loadRunTextures()
    {
        for i in 2...8 {
            let texture = SKTexture(imageNamed: "monkey_run_\(i)")
            runTextures.append(texture)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

