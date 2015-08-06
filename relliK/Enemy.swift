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
        createHealthBar()    }
    func createHealthBar(){
        
        
    }
    func loadedEnemySettings() {
        lightingBitMask = BitMaskOfLighting.left & BitMaskOfLighting.right & BitMaskOfLighting.up & BitMaskOfLighting.down//super.getSideForLighting()
        shadowedBitMask = BitMaskOfLighting.left & BitMaskOfLighting.right & BitMaskOfLighting.up & BitMaskOfLighting.down//super.getSideForLighting()
        
                //texture!.textureByGeneratingNormalMap()
                //texture!.textureByGeneratingNormalMapWithSmoothness(0.3, contrast: 0.6)
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
        runAction(moveAction())
        moveToNextBlock()
        playMoveSound()
    }
    override func moveToNextBlock() {
        super.moveToNextBlock()
        
        if entityCurrentBlock == blockPlace.home{
            self.kill()
        }
    }
    func moveAction() ->SKAction{
        
        let wait = SKAction.waitForDuration(enemyWaitTime)
        
        switch (directionOf){
        case entityDirection.left:
            let moveLeftAction = SKAction.moveByX(incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
            return SKAction.sequence([moveLeftAction, wait])
        case entityDirection.right:
            let moveRightAction = SKAction.moveByX(-incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
            
            return SKAction.sequence([moveRightAction, wait])
        case entityDirection.down:
            let moveDownAction = SKAction.moveByX(0, y: incrementalSpaceBetweenBlocks, duration: gameSpeed)

            return SKAction.sequence([moveDownAction, wait])
        case entityDirection.up:
            let moveUpAction = SKAction.moveByX(0, y: -incrementalSpaceBetweenBlocks, duration: gameSpeed)
            
            return SKAction.sequence([moveUpAction , wait])
        case entityDirection.unSelected:
            //Dont run
            print("direction unselected")
            return SKAction()
        }
    }
    
    //SFX
    override func hurt() {
        super.hurt()
        died()
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
        
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 3
        health = maxHealth
        hurtSoundString = "hurt"
        attackSoundString = "bulletAttack"
        moveSoundString = "move"
        diedSoundString = "died"
        directionOf = entityDirection.unSelected
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.fourth
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
            
            let healthLabel = SKLabelNode(fontNamed: "Chalkduster")
            healthLabel.fontSize = 100
            //healthLabel.alpha = 0.7
            healthLabel.fontColor = SKColor.greenColor()
            healthLabel.name = "healthLabel"
            //
            //healthLabel.zPosition = zPosition + 1
            healthLabel.text = "==="
            
            enemy.addChild(healthLabel)
            healthLabel.position = CGPoint(x: 0.5, y: 20.0)
            healthLabel.runAction(SKAction.rotateToAngle(π, duration: NSTimeInterval(0.0), shortestUnitArc: true))
            
            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(enemy)!
            SharedTexture.texture.filteringMode = .Nearest
            SharedTexture.texture.textureByGeneratingNormalMapWithSmoothness(0.6, contrast: 0.3)
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
        
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 1
        health = maxHealth
        hurtSoundString = "hurt"
        attackSoundString = "attack"
        moveSoundString = "move"
        diedSoundString = "died"
        directionOf = entityDirection.unSelected
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.first
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
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 2
        health = maxHealth
        hurtSoundString = "hurt"
        attackSoundString = "attack"
        moveSoundString = "move"
        diedSoundString = "died"
        directionOf = entityDirection.unSelected
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.second
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
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 1
        health = maxHealth
        hurtSoundString = "hurt"
        attackSoundString = "attack"
        moveSoundString = "move"
        diedSoundString = "died"
        directionOf = entityDirection.unSelected
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.fifth
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
        })
        
        return SharedTexture.texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}