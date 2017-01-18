//
//  RunLeft.swift
//  Ninja
//
//  Created by Chris Pelling on 07/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

class RunLeft: GKState {

    let node:Player
    
    init(withPlayer player:Player)
    {
        node = player
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.removeActionForKey("running")
        node.xScale = -1
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
