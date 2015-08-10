//
//  Player.swift
//  relliK
//
//  Created by Andre Villanueva on 7/30/15.
//  Copyright © 2015 Bang Bang Studios. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Player:Entity {
    
    init(entityPosition: CGPoint) {
        let entityTexture = Player.generateTexture()!
        
        super.init(position: entityPosition, texture: entityTexture)
        //physicsBody!.categoryBitMask = PhysicsCategory.Player
        //        physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        name = "player"
        setScale(playerScale)
        directionOf = entityDirection.down
        zPosition = 100.00
        updateSpriteAtrributes()
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let mainPlayer = SKSpriteNode(imageNamed: "Spaceship")
            mainPlayer.name = "player"
            
            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(mainPlayer)!
            SharedTexture.texture.filteringMode = .Nearest
        })
        
        return SharedTexture.texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setAngle(){
        switch (directionOf){
        case entityDirection.right:
            runAction(SKAction.rotateToAngle(2 * π , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.left:
            runAction(SKAction.rotateToAngle(π, duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.down:
            runAction(SKAction.rotateToAngle((3 / 2) + π , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.up:
            runAction(SKAction.rotateToAngle(π / 2 , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.unSelected:
            //Dont run
            directionOf = entityDirection.unSelected
            print("direction unselected")
        }
    }
    
    override func updateSpriteAtrributes() {
        super.updateSpriteAtrributes()
        physicsBody = SKPhysicsBody(rectangleOfSize: (frame.size))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func setEntityTypeAttribures(){
        maxHealth = 3
        health = maxHealth
        hurtSoundString = "playerPain1.wav"
//        attackSoundString = "attack"
//        moveSoundString = "move"
//        diedSoundString = "died"
//        directionOf = entityDirection.unSelected
//        entityCurrentBlock = blockPlace.unSelected
//        entityInRangeBlock = blockPlace.fourth
        
        //childNodeWithName("bulletNode")
    }
    
    override func died() {
        if isDead{//If dead turns sprite red waits for x seconds and then removes the sprite from parent
            physicsBody?.categoryBitMask = PhysicsCategory.None//Stops all contact and collision detection after death
            runAction(SKAction.sequence([SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 1.0, duration: 0.0),
                SKAction.waitForDuration(0.3),
                SKAction.removeFromParent()]))
        }
}
}

class Bullet: Entity{
    var light = SKLightNode()
    
    init(entityPosition: CGPoint) {
        let entityTexture = Bullet.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        
        color = SKColor.blackColor()
        self.zPosition = CGFloat(90.00)
        self.setScale(bulletScale)
        let shot = SKEmitterNode(fileNamed: "engine")
        shot?.position = CGPoint(x: 0.5, y: 1.0)
        updateSpriteAtrributes()
        attackSoundString = "bulletAttack.wav"
        addChild(shot!)
        
        
        light.position = CGPoint(x: 0.5, y: 0.5)
        light.categoryBitMask = getSideForLighting()
        light.enabled = true
        light.lightColor = SKColor(red: 0, green: 0, blue: 200, alpha: 0.1)
        light.shadowColor = SKColor.blackColor()// SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        light.ambientColor = SKColor(red: 0, green: 0, blue: 200, alpha: 0.1)
        light.falloff = 1.0
        addChild(light)
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
        entityInRangeBlock = blockPlace.fourth
        
        //childNodeWithName("bulletNode")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let bullet = SKSpriteNode(imageNamed: "rainDrop")
            bullet.name = "bullet"
            
            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.textureFromNode(bullet)!
            SharedTexture.texture.filteringMode = .Nearest
            
        })
        
        return SharedTexture.texture
    }
    
    override func setAngle(){
        switch (directionOf){
        case entityDirection.right:
            self.runAction(SKAction.rotateToAngle(2 * π , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.left:
            self.runAction(SKAction.rotateToAngle(π, duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.down:
            self.runAction(SKAction.rotateToAngle((3 / 2) + π , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.up:
            self.runAction(SKAction.rotateToAngle(π / 2 , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.unSelected:
            //Dont run
            directionOf = entityDirection.unSelected
            print("direction unselected")
        }
    }
    
    func moveFunc(){//Sets Angle, moves sprite an then removesSpriteFromParent
        setAngle()
        playattackSound()
        let action = SKAction.sequence([move, SKAction.removeFromParent()])
        runAction(action, withKey: "move")
    }
    
    override func updateSpriteAtrributes() {
        super.updateSpriteAtrributes()
        physicsBody = SKPhysicsBody(rectangleOfSize: (frame.size))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    override func died() {
        super.died()
    }
}