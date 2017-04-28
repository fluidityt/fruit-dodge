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
    
    private let labelNode:SKLabelNode
    private let iconNode: SKSpriteNode
    private let separatorNode: SKLabelNode
    
    public var separator = "x"
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed image:String) {
        
        iconNode = SKSpriteNode(imageNamed: image)

        labelNode = SKLabelNode(fontNamed: "PlaytimeWithHotToddies")
        labelNode.text = "0"
        labelNode.fontSize = 90
        
        separatorNode = SKLabelNode(fontNamed: "PlaytimeWithHotToddies")
        separatorNode.text = separator
        separatorNode.verticalAlignmentMode = .center
        separatorNode.fontSize = 90
        
        labelNode.horizontalAlignmentMode = .left
        labelNode.verticalAlignmentMode = .center
        
        
        labelNode.position = CGPoint(x: separatorNode.frame.size.width, y: 0)
        
        iconNode.position = CGPoint(x: -iconNode.size.width, y: 0)
        
        iconNode.scaleAsSize = CGSize(width: labelNode.frame.size.height, height: labelNode.frame.size.height)
        
        super.init()
        
        addChild(separatorNode)
        addChild(iconNode)
        addChild(labelNode)
    }
    
    func increment() -> SKAction
    {
        return SKAction.run({ Void in
            
            var count = 0
            
            count = Int(self.labelNode.text!) ?? 0

            count+=1
            self.separatorNode.text = self.separator
            self.labelNode.text = String(describing: count)
        })
    }
    
    func setScore(score:Int)
    {
        self.separatorNode.text = self.separator
        self.labelNode.text = String(describing: score)
    }
    
    
    
}
