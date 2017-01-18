//
//  Defeated.swift
//  Ninja
//
//  Created by Chris Pelling on 22/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class Defeated: GKState {
    var node:Player
    
    init(withPlayer player:Player)
    {
        node = player
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.physicsBody?.velocity.dx = 0
        node.removeActionForKey("running")
        node.texture = nil
        node.cropNode.hidden = false
        let pos = node.cropNode.position - CGPoint(x: 0, y: node.size.height/2)
        node.maskNode.runAction(SKAction.moveTo(CGPoint(x:0, y:node.size.height/2), duration: 0.05))
        node.cropNode.runAction(SKAction.moveTo(pos, duration: 0.05))
        
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return false
    }
}
