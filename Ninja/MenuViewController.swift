
//  MenuViewController.swift
//  Ninja
//
//  Created by Chris Pelling on 07/10/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var beginButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginButton.userInteractionEnabled = true
        beginButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(begin)))
        
        // Do any additional setup after loading the view.
    }
    
    func begin()
    {
        let vc = GameViewController()
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
