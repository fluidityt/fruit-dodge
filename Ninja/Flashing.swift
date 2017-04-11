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
    
    override func update(deltaTime seconds: TimeInterval) {
        powerup.timeInExistence+=seconds
        if powerup.timeInExistence > powerup.lifeTime {
            powerup.removeFromParent()
            powerup.deactivate()
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        self.powerup.flash()
    }
}

class Collected: GKState {
    
    var powerup:Powerup
    
    init(withPowerup powerup:Powerup)
    {
        self.powerup = powerup
    }
    
    override func didEnter(from previousState: GKState?) {
        
        powerup.run(powerup.collectionSound, completion: {
            self.powerup.removeFromParent()
            self.powerup.activate()
        }) 
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}


