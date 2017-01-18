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
    
    var node:Player
    
    init(withPlayer player:Player)
    {
        node = player
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.physicsBody?.velocity.dx = 0
        node.removeActionForKey("running")
        node.texture = node.idleTexture
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
