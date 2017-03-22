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
        
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.physicsBody?.velocity.dx = 0
        node.removeActionForKey("running")
        node.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(node.idleTextures, timePerFrame: 0.20)), withKey:"idle")
        
    }
    
    override func willExitWithNextState(nextState: GKState) {
        node.removeActionForKey("idle")
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
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

    
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.physicsBody?.velocity.dx = 0
        node.removeActionForKey("running")
        node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: node.size.height*0.8, height: node.size.width))
        node.physicsBody?.categoryBitMask = PhysicsCategories.character.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategories.topwall.rawValue | PhysicsCategories.sidewall.rawValue
        node.physicsBody?.contactTestBitMask = PhysicsCategories.enemy.rawValue | PhysicsCategories.sidewall.rawValue | PhysicsCategories.powerup.rawValue
        node.runAction(SKAction.animateWithTextures(node.defeatedTextures, timePerFrame: 0.01, resize: true, restore: false))
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return false
    }
}

class Hit: GKState {
    
    var entryState:GKState.Type?
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        self.entryState = previousState!.dynamicType
        
        node.removeActionForKey("running")
        node.runAction(SKAction.animateWithTextures(node.hitTextures, timePerFrame: 0.10)) {
            
            self.node.state.enterState(self.entryState!)
        }
        
    }
    
    /*override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if (seconds > 2.0) {
                node.physicsBody?.contactTestBitMask = PhysicsCategories.enemy.rawValue | PhysicsCategories.sidewall.rawValue | PhysicsCategories.powerup.rawValue
        }
    }*/
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true
    }
}

class RunLeft: GKState {
    

    override func didEnterWithPreviousState(previousState: GKState?) {
        node.removeActionForKey("running")
        if (node.xScale > 0) {
            node.xScale = -node.xScale
        }
        node.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(node.runTextures, timePerFrame: 0.05)), withKey:"running")
        node.physicsBody?.velocity.dx = -node.runSpeed
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
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
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}

class RunRight: GKState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.removeActionForKey("running")
        node.xScale = abs(node.xScale)
        node.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(node.runTextures, timePerFrame: 0.05)), withKey: "running")
        node.physicsBody?.velocity.dx = node.runSpeed
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
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
    
    
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {

    }
    
    override func willExitWithNextState(nextState: GKState) {
        
    }
}

extension GKState {
    var node:Player {
        get {
            let state = self.stateMachine as! PlayerState
            return state.player
        }
    }
}


