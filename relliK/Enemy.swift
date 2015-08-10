//
//  Enemy.swift
//  Colored War
//
//  Created by Andre Villanueva on 6/4/15.
//  Copyright (c) 2015 BangBangStudios. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class Enemy: Entity{
    
    //Initializars
    init(texture: SKTexture) {
        super.init(position: CGPoint(), texture: texture)
        directionOf = entityDirection.unSelected
        size = texture.size()
        setScale(enemyScale)
        zPosition = 90.00
        updateSpriteAtrributes()
        createHealthBar()
        
    }
    func createHealthBar(){
        
        
    }
    func loadedEnemySettings() {//Turns on Lighting and shadowing
//        lightingBitMask = super.getSideForLighting()
//        shadowedBitMask = super.getSideForLighting()
    }
    override func updateSpriteAtrributes() {
        super.updateSpriteAtrributes()
        physicsBody = SKPhysicsBody(rectangleOfSize: (frame.size))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
        physicsBody?.collisionBitMask = PhysicsCategory.None
        loadedEnemySettings()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Action Methods
    func moveFunc(){
        setAngle()
        move.timingMode = SKActionTimingMode.EaseInEaseOut
        runAction(moveAction(), withKey: "move")
        playMoveSound()
    }
    override func moveToNextBlock() {
        super.moveToNextBlock()
        
//        if entityCurrentBlock == blockPlace.home{
//            self.kill()
//        }
    }
    func moveAction() ->SKAction{
        defer{
            loadedEnemySettings()
        }
        
        let wait = SKAction.waitForDuration(enemyWaitTime)
        
        let moveToNextBlockAction = SKAction.runBlock({
            node in
            self.moveToNextBlock()
        })
        
        switch (directionOf){
        case entityDirection.left:
            let moveLeftAction = SKAction.moveByX(incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
            return SKAction.sequence([moveToNextBlockAction, wait, moveLeftAction])
        case entityDirection.right:
            let moveRightAction = SKAction.moveByX(-incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
            
            return SKAction.sequence([moveToNextBlockAction, wait, moveRightAction])
        case entityDirection.down:
            let moveDownAction = SKAction.moveByX(0, y: incrementalSpaceBetweenBlocks, duration: gameSpeed)
            
            return SKAction.sequence([moveToNextBlockAction, wait, moveDownAction])
        case entityDirection.up:
            let moveUpAction = SKAction.moveByX(0, y: -incrementalSpaceBetweenBlocks, duration: gameSpeed)
            
            return SKAction.sequence([moveToNextBlockAction, wait, moveUpAction])
        case entityDirection.unSelected:
            //Dont run
            print("direction unselected")
            assertionFailure("Entity direction was never sent, this should never happen")
            return SKAction()
        }
        
    }
    
    //SFX
    override func hurt() {
        super.hurt()
        died()
    }
    override func died() {
        if isDead{//If dead turns sprite red waits for x seconds and then removes the sprite from parent
            physicsBody?.categoryBitMask = PhysicsCategory.None//Stops all contact and collision detection after death
            removeActionForKey("move")
            runAction(SKAction.sequence([SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 1.0, duration: 0.0),
                SKAction.waitForDuration(0.3),
                SKAction.removeFromParent()]))
    }
}
}
class Boss:Enemy {
    
    init(entityPosition: CGPoint) {
        let entityTexture = Boss.generateTexture()!
        
        super.init(texture: entityTexture)
        position = entityPosition
        name = "boss"
        setScale(enemyScale)
        directionOf = entityDirection.unSelected
        setEntityTypeAttribures()
        
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 3
        health = maxHealth
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.fourth
                hurtSoundString = "bossHurt.wav"
                attackSoundString = "attack.wav"
                moveSoundString = "move.wav"
                diedSoundString = "died.wav"
        //        directionOf = entityDirection.unSelected
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let enemy = SKSpriteNode(imageNamed: "enemy")
            
//            healthLabel = SKLabelNode(fontNamed: "Chalkduster")
//            healthLabel.fontSize = 100
//            //healthLabel.alpha = 0.7
//            healthLabel.fontColor = SKColor.greenColor()
//            healthLabel.name = "healthLabel"
//            //
//            //healthLabel.zPosition = zPosition + 1
//            var healthString: Int!
////            while var i <= healthString{
////                healthString++
////                i++
////            }
//            healthLabel.text = String(healthString)
//            
//            
//            healthLabel.position = CGPoint(x: 0.5, y: (enemy.texture?.size().height)!)// + (healthLabel.frame.size.height / 2))
//            enemy.addChild(healthLabel)
//            healthLabel.runAction(SKAction.rotateToAngle(π, duration: NSTimeInterval(0.0), shortestUnitArc: true))
//            

            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(enemy)!
            SharedTexture.texture.filteringMode = .Nearest
            SharedTexture.texture.textureByGeneratingNormalMapWithSmoothness(0.6, contrast: 1.0)
        })
        
        return SharedTexture.texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Ghost: Enemy{
    
    init(entityPosition: CGPoint) {
        let entityTexture = Ghost.generateTexture()!
        
        super.init(texture: entityTexture)
        position = entityPosition
        name = "ghost"
        setScale(enemyScale)
        directionOf = entityDirection.unSelected
        setEntityTypeAttribures()
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 1
        health = maxHealth
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.first
        
                hurtSoundString = "ghostHurt.wav"
                attackSoundString = "attack.wav"
                moveSoundString = "move.wav"
                diedSoundString = "died.wav"
                directionOf = entityDirection.unSelected
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let enemy = SKSpriteNode(imageNamed: "cat")
            enemy.color = SKColor.yellowColor()
            enemy.colorBlendFactor = 0.8
            
            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(enemy)!
            SharedTexture.texture.filteringMode = .Nearest
            SharedTexture.texture.textureByGeneratingNormalMapWithSmoothness(0.6, contrast: 1.0)
        })
        
        return SharedTexture.texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Soldier: Enemy{
    
    init(entityPosition: CGPoint) {
        
        let entityTexture = Soldier.generateTexture()!
        
        super.init(texture: entityTexture)
        
        position = entityPosition
        name = "soldier"
        setScale(enemyScale)
        directionOf = entityDirection.unSelected
        setEntityTypeAttribures()
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 2
        health = maxHealth
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.second
                hurtSoundString = "soldierHurt.wav"
                attackSoundString = "attack.wav"
                moveSoundString = "move.wav"
                diedSoundString = "died.wav"
        //        directionOf = entityDirection.unSelected
        
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let enemy = SKSpriteNode(imageNamed: "zombie1")
            enemy.name = "soldier"
            
            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(enemy)!
            SharedTexture.texture.filteringMode = .Nearest
            SharedTexture.texture.textureByGeneratingNormalMapWithSmoothness(0.6, contrast: 1.0)
        })
        
        return SharedTexture.texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Minion:Enemy {
    
    init(entityPosition: CGPoint) {
        
        let entityTexture = Minion.generateTexture()!
        
        super.init(texture: entityTexture)
        position = entityPosition
        name = "ninion"
        setScale(enemyScale)
        directionOf = entityDirection.unSelected
        setEntityTypeAttribures()
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 1
        health = maxHealth
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.fifth
                hurtSoundString = "minionHurt.wav"
                attackSoundString = "attack.wav"
                moveSoundString = "move.wav"
                diedSoundString = "died.wav"
        //        directionOf = entityDirection.unSelected
        
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let enemy = SKSpriteNode(imageNamed: "cat")
            enemy.name = "minion"
            
            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(enemy)!
            SharedTexture.texture.filteringMode = .Nearest
            SharedTexture.texture.textureByGeneratingNormalMapWithSmoothness(0.6, contrast: 1.0)
        })
        
        return SharedTexture.texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}