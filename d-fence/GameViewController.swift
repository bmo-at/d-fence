//
//  GameViewController.swift
//  d-fence
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    // MARK: Main Game View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = MainMenuScene(size: self.view.frame.size)
            
            // Present the scene
            view.presentScene(scene)
            
            // Setup the view
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = false
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
