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
        view = SKView(frame: UIScreen.mainScreen().bounds)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
         let gameSize = CGSize(width: 2048, height: 1536)
        
         let scene = GameScene(size: gameSize)
            // Configure the view.
            let skView = self.view as! SKView
        
            TextureLoader.preloadTextures()


            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            //skView.showsPhysics = true
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
