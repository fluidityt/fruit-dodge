//
//  Flashing.swift
//  Ninja
//
//  Created by Chris Pelling on 16/02/2017.
//  Copyright © 2017 Compelling. All rights reserved.
//

import UIKit
import GameplayKit

class Flashing: GKState {
    var powerup:Powerup
    
    init(withPowerup powerup:Powerup)
    {
        self.powerup = powerup
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        powerup.timeInExistence+=seconds
        if powerup.timeInExistence > powerup.lifeTime {
            powerup.removeFromParent()
            powerup.deactivate()
        }
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        self.powerup.flash()
    }
}

class Collected: GKState {
    
    var powerup:Powerup
    
    init(withPowerup powerup:Powerup)
    {
        self.powerup = powerup
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        powerup.removeFromParent()
        powerup.activate()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return false
    }
}


