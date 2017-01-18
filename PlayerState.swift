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

class PlayerState: GKStateMachine {
    
    init(player:Player) {
        
        var states = [GKState]()
        
        //let frameWidth:CGFloat = 1.0/8
        //var leftFrames = [SKTexture]()
        //var rightFrames = [SKTexture]()
        
        //for i in 2..<9 {
            //let x = frameWidth*CGFloat(i)
            //let rect = CGRect(x: x, y: 0, width: frameWidth, height: textureSize.height)
            //print(rect)
            /*let leftRect = CGRect(x: x, y: 0.0, width: frameWidth, height: 0.5)
            let rightRect = CGRect(x: x, y: 0.5, width: frameWidth, height: 0.5)
            
            let leftFrame = SKTexture(rect: leftRect, inTexture: texture)
            let rightFrame = SKTexture(rect: rightRect, inTexture: texture)
            leftFrames.append(leftFrame)
            rightFrames.append(rightFrame)*/
            
            // Texture generation should be part of the player character code. State machine should just access them.
            //let texture = SKTexture(imageNamed: "monkey_run_\(i)")
            //rightFrames.append(texture)
            
        //}
        
        states = [Standing(withPlayer: player), RunRight(withPlayer: player), RunLeft(withPlayer: player), Defeated(withPlayer:player)]
        super.init(states: states)
    }
    
}
