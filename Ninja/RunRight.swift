//
//  RunRight.swift
//  Ninja
//
//  Created by Chris Pelling on 07/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

class RunRight: GKState {
    
    var node:Player
    var startTime:Double = 0.0
    
    init(withPlayer player:Player)
    {
        node = player
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        startTime = CACurrentMediaTime()
        node.removeActionForKey("running")
        node.xScale = 1
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
        print(CACurrentMediaTime() - startTime)
    }
}
