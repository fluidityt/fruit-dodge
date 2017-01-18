//
//  CountdownNode.swift
//  Ninja
//
//  Created by Chris Pelling on 17/01/2017.
//  Copyright © 2017 Compelling. All rights reserved.
//

import UIKit
import SpriteKit

class CountdownNode: SKSpriteNode {
    
    private var count:Int
    private var delay:NSTimeInterval
    private var countdownLabel = SKLabelNode()
    
    init(size: CGSize, count: Int, delay: NSTimeInterval, bgColor:UIColor)
    {
        self.count = count
        self.delay = delay
        super.init(texture: nil, color: bgColor, size: size)
        anchorPoint = CGPoint(x: 0, y: 0)
        //self.position = CGPoint(x: size.width/2, y: size.height/2)
        print(anchorPoint)
        initChildren()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initChildren()
    {
        let countdownLayer = SKNode()
        countdownLayer.name = "countdown"
        countdownLayer.position = CGPoint(x: size.width/2, y: size.height/2)
        
        let fontScaleFactor =  min(size.width/countdownLabel.frame.width, size.height/countdownLabel.frame.height)*0.8
        countdownLabel.fontSize *= fontScaleFactor
        print(fontScaleFactor)
        countdownLabel.fontSize = 50
        
        addChild(countdownLayer)
        countdownLabel.text = "Ready?"
        countdownLayer.addChild(countdownLabel)
    }
    
    func start(completion: (() -> Void)?)
    {
        var countDownTimer = count
        let wait = SKAction.waitForDuration(delay)
        let updateLabel = SKAction.runBlock({
            if countDownTimer == 0 {
                self.countdownLabel.text = "Go!"
            } else {
                self.countdownLabel.text = String(countDownTimer)
                print(countDownTimer)
                countDownTimer -= 1
            }
        })
        
        let doTimer = SKAction.sequence([updateLabel, wait])
        self.runAction(SKAction.repeatAction(doTimer, count: count)) {
            let slide = SKAction.moveBy(CGVector(dx: 0, dy: -self.size.height), duration: 0.3)
            slide.timingMode = .EaseOut
            
            self.runAction(slide) {
                self.removeFromParent()
                completion?()
            }
        }
    }
    
    
    
}
