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
            return false
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
            return false
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}

class RunRight: GKState {
    
    //var node:Player
    var startTime:Double = 0.0
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        startTime = CACurrentMediaTime()
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
            return false
        }
    }
    
    
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        //node.physicsBody?.velocity.dx = 200
        //print(seconds)
        /*if (lastUpdate == 0.0) {
         node.timeMoving = CGFloat(seconds)
         } else {
         node.timeMoving = node.timeMoving - CGFloat(seconds)
         }*/
    }
    
    override func willExitWithNextState(nextState: GKState) {
        //print(CACurrentMediaTime() - startTime)
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


