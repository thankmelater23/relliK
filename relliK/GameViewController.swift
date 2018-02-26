//
//  GameViewController.swift
//  relliK
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright (c) 2015 Bang Bang Studios. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: 2208, height: 1242)
        let gameScene = GameScene(size: size)
        let gameOverScene = GameOverScene(size: size, won: false)
        let mainMenuScene = MainMenuScene(size: size)
        //        let scene = GameScene(size: CGSize(width: 1136, height: 640))
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
