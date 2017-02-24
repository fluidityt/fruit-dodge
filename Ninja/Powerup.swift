//
//  Powerup.swift
//  Ninja
//
//  Created by Chris Pelling on 10/02/2017.
//  Copyright © 2017 Compelling. All rights reserved.
//

import UIKit
import GameplayKit

protocol Powerupable
{
    func didExecutePowerup(powerup:Powerup)
    //var delegate:AnyObject { get set }
}

class PowerupFactory {
    
    static var powerups:[String:Powerup] = [:]
    
    static func createPowerupOfType(type:String) -> Powerup?
    {
        var powerup:Powerup
        
        if let existing = self.powerups[type] {
            powerup = existing.copy() as! Powerup
        } else {
            switch(type) {
                case "star":
                return Star()
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
    
    init() {
        
    
        let texture = SKTexture(imageNamed: "star")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: texture.size().width, height: texture.size().height))
        self.physicsBody?.affectedByGravity = true
        
        self.physicsBody?.categoryBitMask = PhysicsCategories.powerup.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.powerup.rawValue
        self.physicsBody?.allowsRotation = false
        
        state = GKStateMachine(states: [Collectible(withPowerup: self), Flashing(withPowerup:self)])
        self.name = "powerup"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flash()
    {
        let fadeoutAction = SKAction.fadeOutWithDuration(0.1)
        let fadeinAction = SKAction.fadeInWithDuration(0.1)
        let flashAction = SKAction.sequence([fadeoutAction, fadeinAction])
        self.runAction(SKAction.repeatActionForever(flashAction))
    }
    
    func stopFlashing()
    {
        // Remove action
    }
    
    func action(obj: AnyObject) {}
    
}

class Star:Powerup
{
    override func action(obj: AnyObject) {
        
        let scene = obj as! GameScene
        
        scene.starScore+=1
    }
}
