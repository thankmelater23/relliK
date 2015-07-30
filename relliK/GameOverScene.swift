//
//  GameOverScene.swift
//  TillTheeEnd
//
//  Created by Andre Villanueva on 7/19/15.
//  Copyright © 2015 Bang Bang Studios. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    let won: Bool
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        var background: SKSpriteNode
        
        if(won){
            background = SKSpriteNode(imageNamed: "YouWin")
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                SKAction.playSoundFileNamed("win.wav",
                    waitForCompletion: false)
                ]))
        }else{
            background = SKSpriteNode(imageNamed: "YouLose")
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                SKAction.playSoundFileNamed("lose.wave",
                    waitForCompletion: false)
                ]))
        }
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        let wait = SKAction.waitForDuration(3.0)
        let block = SKAction.runBlock{
            let myScene = MainMenuScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(SKAction.sequence([wait,block]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
