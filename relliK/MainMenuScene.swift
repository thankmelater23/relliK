//
//  MainMenuScene.swift
//  TillTheeEnd
//
//  Created by Andre Villanueva on 7/19/15.
//  Copyright © 2015 Bang Bang Studios. All rights reserved.
//

import Foundation
import Foundation
import SpriteKit

class MainMenuScene: SKScene {

    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to _: SKView) {
        let background: SKSpriteNode = SKSpriteNode(imageNamed: "mainMenue")

        addChild(background)
    }
}
