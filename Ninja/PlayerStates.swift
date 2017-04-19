//
//  Standing.swift
//  Ninja
//
//  Created by Chris Pelling on 07/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

class Standing: GKState {
        
    override func didEnter(from previousState: GKState?) {
        node.physicsBody?.velocity.dx = 0
        node.removeAction(forKey: "running")
        node.run(SKAction.repeatForever(SKAction.animate(with: node.idleTextures, timePerFrame: 0.20)), withKey:"idle")
        
    }
    
    override func willExit(to nextState: GKState) {
        node.removeAction(forKey: "idle")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RunLeft.Type:
            return true
        case is RunRight.Type:
            return true
        case is Defeated.Type:
            return true
        default:
            return true
        }
    }
}

class Defeated: GKState {

    
    override func didEnter(from previousState: GKState?) {
        node.physicsBody?.velocity.dx = 0
        node.removeAction(forKey: "running")
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.height*0.8, height: node.size.width))
        node.physicsBody?.categoryBitMask = PhysicsCategories.character.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.sidewall.rawValue
        node.physicsBody?.contactTestBitMask = PhysicsCategories.enemy.rawValue | PhysicsCategories.sidewall.rawValue | PhysicsCategories.powerup.rawValue
        node.run(SKAction.animate(with: node.defeatedTextures, timePerFrame: 0.01, resize: true, restore: false))
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}

class Hit: GKState {
    
    var entryState:GKState.Type?
    
    override func didEnter(from previousState: GKState?) {
        
        self.entryState = type(of: previousState!)
        
        node.removeAction(forKey: "running")
        node.run(SKAction.animate(with: node.hitTextures, timePerFrame: 0.10), completion: {
            
            self.node.state.enter(self.entryState!)
        }) 
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
}

class RunLeft: GKState {
    

    override func didEnter(from previousState: GKState?) {
        node.removeAction(forKey: "running")
        if (node.xScale > 0) {
            node.xScale = -node.xScale
        }
        node.run(SKAction.repeatForever(SKAction.animate(with: node.runTextures, timePerFrame: 0.05)), withKey:"running")
        node.physicsBody?.velocity.dx = -node.runSpeed
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is Standing.Type:
            return true
        case is RunRight.Type:
            return true
        case is Defeated.Type:
            return true
        default:
            return true
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}

class RunRight: GKState {
    
    override func didEnter(from previousState: GKState?) {
        node.removeAction(forKey: "running")
        node.xScale = abs(node.xScale)
        node.run(SKAction.repeatForever(SKAction.animate(with: node.runTextures, timePerFrame: 0.05)), withKey: "running")
        node.physicsBody?.velocity.dx = node.runSpeed
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is RunLeft.Type:
            return true
        case is Standing.Type:
            return true
        case is Defeated.Type:
            return true
        default:
            return true
        }
    }
    
    
    
    override func update(deltaTime seconds: TimeInterval) {

    }
    
    override func willExit(to nextState: GKState) {
        
    }
}

extension GKState {
    var node:Player {
        get {
            let state = self.stateMachine as! PlayerState
            return state.player!
        }
    }
}


