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
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}


class Bullet: Entity{
    
    init(entityPosition: CGPoint) {
        let entityTexture = Bullet.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        
        color = SKColor.blackColor()
        self.zPosition = CGFloat(90.00)
        self.setScale(bulletScale)
        let shot = SKEmitterNode(fileNamed: "engine")
        shot?.position = CGPoint(x: 0.5, y: 1.0)
        updateSpriteAtrributes()
        addChild(shot!)
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
        runAction(SKAction.sequence([move, SKAction.removeFromParent()]))
    }
    
    override func updateSpriteAtrributes() {
        super.updateSpriteAtrributes()
        physicsBody = SKPhysicsBody(rectangleOfSize: (frame.size))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}