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
        print(seconds);
    }
}


