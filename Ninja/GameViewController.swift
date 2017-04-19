//
//  GameViewController.swift
//  Ninja
//
//  Created by Chris Pelling on 02/09/2016.
//  Copyright (c) 2016 Compelling. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func loadView() {
        view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
         let gameSize = CGSize(width: 2048, height: 1536)
        
         let scene = GameScene(size: gameSize)
            // Configure the view.
            let skView = self.view as! SKView

        
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            //let weakSelf = weak self
            scene.dismiss = {
                skView.presentScene(nil)
                self.dismiss(animated: true, completion: {})
            }
            skView.presentScene(scene)
            //skView.showsPhysics = true
        
        
    
        
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
