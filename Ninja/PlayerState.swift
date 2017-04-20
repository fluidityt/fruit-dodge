//
//  MovementState.swift
//  Ninja
//
//  Created by Chris Pelling on 07/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

class PlayerStateMachine: GKStateMachine {
    
    weak var player:Player?
    
    init(player:Player) {
        
        self.player = player
        
        var states = [GKState]()
    
        states = [Standing(), RunRight(), RunLeft(), Defeated()]
        super.init(states: states)
    }    
}
