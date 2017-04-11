//
//  Powerup.swift
//  Ninja
//
//  Created by Chris Pelling on 10/02/2017.
//  Copyright © 2017 Compelling. All rights reserved.
//

import UIKit
import GameplayKit

protocol Powerupable:class
{
    func didExecutePowerup(_ powerup:Powerup)
    func didFinishExecutingPower(_ powerup:Powerup)
}

class PowerupFactory {
    
    static var powerups:[String:Powerup] = [:]
    
    static func createPowerupOfType(_ type:String) -> Powerup?
    {
        var powerup:Powerup
        
        if let existing = self.powerups[type] {
            powerup = existing.copy() as! Powerup
        } else {
            switch(type) {
                case "star":
                return Star()
                case "lightning":
                return Lightning()
            default:
                return nil;
            }
        }
        return powerup
    }
}


class Powerup: SKSpriteNode {
    
    var state:GKStateMachine? = nil
    var timeInExistence:CFTimeInterval = 0.0
    weak var delegate:Powerupable?
    var collectionSound:SKAction = SKAction()
    var lifeTime:CFTimeInterval = 6.0
    
    fileprivate init(texture:String) {
        
    
        let texture = SKTexture(imageNamed: texture)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width, height: texture.size().height))
        self.physicsBody?.affectedByGravity = true
        
        self.physicsBody?.categoryBitMask = PhysicsCategories.powerup.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.powerup.rawValue
        self.physicsBody?.allowsRotation = false
        
        state = GKStateMachine(states: [Collectible(withPowerup: self), Flashing(withPowerup:self), Collected(withPowerup: self)])
        self.name = "powerup"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flash()
    {
        let fadeoutAction = SKAction.fadeAlpha(to: 0.01, duration: 0.1)
        let fadeinAction = SKAction.fadeIn(withDuration: 0.1)
        let flashAction = SKAction.sequence([fadeoutAction, fadeinAction])
        self.run(SKAction.repeatForever(flashAction))
    }
    

    func activate() {
        delegate?.didExecutePowerup(self)
    }
    
    func deactivate() {
        delegate?.didFinishExecutingPower(self)
    }
    
    
    
}

class Star:Powerup
{
    init() {
        super.init(texture: "newstar")
        collectionSound = SKAction.playSoundFileNamed("star_collect.mp3", waitForCompletion: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Lightning:Powerup
{
    init() {
        super.init(texture: "lightning")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


