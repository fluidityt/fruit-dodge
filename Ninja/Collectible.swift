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
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        powerup.timeInExistence+=seconds
        if powerup.timeInExistence > 4.0 {
            powerup.state!.enterState(Flashing)
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is Flashing.Type :
            return true
        default:
            return false
        }
    }
}
