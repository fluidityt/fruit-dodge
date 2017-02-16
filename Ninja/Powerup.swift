//
//  Powerup.swift
//  Ninja
//
//  Created by Chris Pelling on 10/02/2017.
//  Copyright © 2017 Compelling. All rights reserved.
//

import UIKit
import GameplayKit

class Powerup: SKSpriteNode {
    
    var state:GKStateMachine? = nil
    var timeInExistence:CFTimeInterval = 0.0
    
    init(withType:String) {
        
    
        let texture = SKTexture(imageNamed: "star")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: texture.size().width, height: texture.size().height))
        self.physicsBody?.affectedByGravity = true
        
        self.physicsBody?.categoryBitMask = PhysicsCategories.powerup.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.powerup.rawValue
        self.physicsBody?.allowsRotation = false
        
        state = GKStateMachine(states: [Collectible(withPowerup: self)])
        self.name = "powerup"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
