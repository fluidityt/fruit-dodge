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
    
    fileprivate var count:Int {
        didSet {
            internalCount-=oldValue
            internalCount+=count
        }
    }
    fileprivate var delay:TimeInterval
    fileprivate var countdownLabel = SKLabelNode(fontNamed: "French_Fries")
    fileprivate var internalCount:Int = 0
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
    
    init(size: CGSize, count: Int, delay: TimeInterval, bgColor:UIColor)
    {
        self.count = count
        self.internalCount = count
        self.delay = delay
        
        bgLayer = SKSpriteNode(texture: nil, color: bgColor, size: size)
        //bgLayer.zPosition = -1
        super.init(texture: nil, color: UIColor.clear, size: size)
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
    
    fileprivate func initChildren()
    {
        let countdownLayer = SKNode()
        countdownLayer.name = "countdown"
        countdownLayer.position = CGPoint(x: size.width/2, y: size.height/2)
        countdownLayer.addChild(countdownLabel)
      
        countdownLabel.fontSize = 500
        countdownLabel.verticalAlignmentMode = .center
        countdownLabel.position = CGPoint(x:0, y: 0)
        
        countdownLabel.text = initialText
        
        addChild(countdownLayer)
    }
    
    func start(_ completion: (() -> Void)?)
    {
        var countDownTimer = count
        var internalTimer = internalCount
        let wait = SKAction.wait(forDuration: delay)
        let updateLabel = SKAction.run({
                      
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
        self.run(SKAction.repeat(doTimer, count: internalCount), completion: {
            let slide = SKAction.move(by: CGVector(dx: 0, dy: -self.size.height), duration: 0.3)
            slide.timingMode = .easeOut
            
            self.run(slide, completion: {
                self.removeFromParent()
                completion?()
            }) 
        }) 
    }
}


