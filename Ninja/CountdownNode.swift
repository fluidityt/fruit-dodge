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
    
    private var count:Int {
        didSet {
            internalCount-=oldValue
            internalCount+=count
        }
    }
    private var delay:NSTimeInterval
    private var countdownLabel = SKLabelNode(fontNamed: "French_Fries")
    private var internalCount:Int = 0
    var initialText:String? {
        didSet {
            if initialText != nil {
                internalCount+=1
            } else {
                internalCount-=1
            }
        }
    }
    var finalText:String? {
        didSet {
            if (finalText != nil) {
                internalCount+=1
            } else {
                internalCount-=1
            }
        }
    }
    
    override var alpha: CGFloat {
        get {
            return self.bgLayer.alpha
        } set {
            self.bgLayer.alpha = newValue
        }
    }
    
    var scaleHeight:CGFloat = 0.4
    var bgLayer:SKSpriteNode
    
    init(size: CGSize, count: Int, delay: NSTimeInterval, bgColor:UIColor)
    {
        self.count = count
        self.internalCount = count
        self.delay = delay
        
        bgLayer = SKSpriteNode(texture: nil, color: bgColor, size: size)
        //bgLayer.zPosition = -1
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        bgLayer.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(bgLayer)
        self.zPosition = 10000
        anchorPoint = CGPoint(x: 0, y: 0)
        countdownLabel.text = String(count)
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
        countdownLayer.addChild(countdownLabel)
      
        let fontScaleFactor =  min(size.width/countdownLabel.frame.width, size.height/countdownLabel.frame.height)
        //countdownLabel.fontSize *= fontScaleFactor*scaleHeight
        countdownLabel.fontSize = 500
        countdownLabel.verticalAlignmentMode = .Center
        countdownLabel.position = CGPoint(x:0, y: 0)
        
        countdownLabel.text = initialText
        
        addChild(countdownLayer)
    }
    
    func start(completion: (() -> Void)?)
    {
        var countDownTimer = count
        var internalTimer = internalCount
        let wait = SKAction.waitForDuration(delay)
        let updateLabel = SKAction.runBlock({
                      
            internalTimer-=1
            
            if (internalTimer > countDownTimer) {
                self.countdownLabel.text = self.initialText
            }
            else if countDownTimer == 0 {
                self.countdownLabel.text = self.finalText
            } else {
                self.countdownLabel.text = String(countDownTimer)
                countDownTimer -= 1
            }
            
        })
        
        let doTimer = SKAction.sequence([updateLabel, wait])
        self.runAction(SKAction.repeatAction(doTimer, count: internalCount)) {
            let slide = SKAction.moveBy(CGVector(dx: 0, dy: -self.size.height), duration: 0.3)
            slide.timingMode = .EaseOut
            
            self.runAction(slide) {
                self.removeFromParent()
                completion?()
            }
        }
    }
}


