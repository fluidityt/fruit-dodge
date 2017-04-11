//
//  Normal.swift
//  Ninja
//
//  Created by Chris Pelling on 16/02/2017.
//  Copyright © 2017 Compelling. All rights reserved.
//

import UIKit
import GameplayKit

class Collectible: GKState {

    var powerup:Powerup
    
    init(withPowerup powerup:Powerup)
    {
        self.powerup = powerup
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        powerup.timeInExistence+=seconds
        if powerup.timeInExistence > 4.0 {
            powerup.state!.enter(Flashing.self)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is Flashing.Type :
            return true
        default:
            return true
        }
    }
}
