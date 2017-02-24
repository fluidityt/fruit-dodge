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
        if powerup.timeInExistence > 2.0 {
            powerup.removeFromParent()
        }
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        self.powerup.flash()
    }
}


