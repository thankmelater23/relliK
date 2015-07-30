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

struct attributes {
    var health: Int! = 0
    var bulletDistance: Int!
    var color: UIColor!
    var hurtSound: String = String()
    //    var diedSound: String = String()
    //    var victorySound: String = String()
    //    var moveSound: String = String()
    //    var type: blockLabel!
    //    var angle: CGFloat
    //    var image: UIImage!
    
    init(){
        health = 0
        bulletDistance = 0
        color = SKColor.blackColor()
        hurtSound = "hurtSound"
        
    }
}

class Entity: SKSpriteNode {
    var myAttributes = attributes()
    var directionOf = entityDirection.unSelected
    var blockOf = block.unSelected
    var move: SKAction = SKAction()
    
    var isDead: Bool{
        return 1 < 1
    }
    
    init(position: CGPoint, texture: SKTexture) {
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())
        self.position = position
        //            health = 0
        //            bulletDistance = 0
        //            color = SKColor.blackColor()
        //            hurtSound = "hurtSound"
        //            diedSound = "hurtSound"
        //            victorySound = "hurtSound"
        //            moveSound = "hurtSound"
        //            angle = 0.00
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func generateTexture() -> SKTexture? {
        // Overridden by subclasses
        return nil
    }
    
    func update(delta: NSTimeInterval) {
        // Overridden by subclasses
    }
    
    
    func setAngle(){
        switch (directionOf){
        case entityDirection.left:
            runAction(SKAction.rotateToAngle(2 * π , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.right:
            runAction(SKAction.rotateToAngle(π, duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.up:
            runAction(SKAction.rotateToAngle((3 / 2) + π , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.down:
            runAction(SKAction.rotateToAngle(π / 2 , duration: NSTimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.unSelected:
            //Dont run
            print("direction unselected")
        }
    }
}

class Enemy: Entity{
    
    init(texture: SKTexture) {
        super.init(position: CGPoint(), texture: texture)
        directionOf = entityDirection.down
        size = texture.size()
        setScale(enemyScale)
        zPosition = 90.00
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveFunc(){
        setAngle()
        runAction(move)
    }
}

class Player:Entity {
    
    init(entityPosition: CGPoint) {
        let entityTexture = Player.generateTexture()!
        
        super.init(position: entityPosition, texture: entityTexture)
        
        name = "player"
        setScale(playerScale)
        directionOf = entityDirection.down
        zPosition = 100.00
    }
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let mainPlayer = SKSpriteNode(imageNamed: "enemy")
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
    
    override class func generateTexture() -> SKTexture? {
        // 1
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&SharedTexture.onceToken, {
            // 2
            let enemy = SKSpriteNode(imageNamed: "Spaceship")
            
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


class Ghost: Enemy{
    init(entityPosition: CGPoint) {
        let entityTexture = Ghost.generateTexture()!
        
        super.init(texture: entityTexture)
        position = entityPosition
        name = "ghost"
        setScale(enemyScale)
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
            enemy.color = SKColor.blackColor()
            enemy.colorBlendFactor = 1.0
            
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
        //        character = SKSpriteNode(imageNamed: "cat")
        //        character.color = SKColor.greenColor()
        //        character.colorBlendFactor = 1.0
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

class Bullet: Entity{
    var directionTo: entityDirection = .unSelected
    var blockOn: block = block.unSelected
    
    init(entityPosition: CGPoint) {
        let entityTexture = Bullet.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        
        color = SKColor.blackColor()
        //        bulletOf.color = color
        //        bulletOf.colorBlendFactor = 1.0
        self.zPosition = CGFloat(90.00)
        self.setScale(bulletScale)
        
        let shot = SKEmitterNode(fileNamed: "engine")
        shot?.position = CGPoint(x: 0.5, y: 1.0)
        self.addChild(shot!)
        
        //    let hurtSound: String = String()
        //    let diedSound: String = String()
        //    let victorySound: String = String()
        //    let moveSound: String = String()
        //    let type = blockLabel.empty
        
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
        switch (directionTo){
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
            directionTo = entityDirection.unSelected
            print("direction unselected")
        }
    }
    
    func moveFunc(){
        setAngle()
        runAction(move)
        
    }
}