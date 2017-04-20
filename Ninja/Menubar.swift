//
//  Healthbar.swift
//  Ninja
//
//  Created by Chris Pelling on 02/03/2017.
//  Copyright © 2017 Compelling. All rights reserved.
//

import UIKit
import SpriteKit

class ScoreNode: SKNode {
    
    private let label:SKLabelNode
    private let icon: SKSpriteNode
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed image:String) {
        
        icon = SKSpriteNode(imageNamed: image)

        label = SKLabelNode(fontNamed: "PlaytimeWithHotToddies")
        label.text = "x 0"
        label.fontSize = 120
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        
        icon.position = CGPoint(x: -icon.size.width, y: 0)
        
        super.init()
        
        addChild(icon)
        addChild(label)
    }
    
    func increment() -> SKAction
    {
        return SKAction.run({ Void in
            
            var count = 0
            
            if let currentText = self.label.text {
                let parts = currentText.components(separatedBy: " ")
                if (parts.count > 1) {
                    count = Int(parts[1]) ?? 0
                }
            }
            
            count+=1
            self.label.text = "x \(String(describing: count))"
        })
    }
    
    func setScore(score:Int)
    {
        self.label.text = "x \(String(describing: score))"
    }
    
    
    
}
