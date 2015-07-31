//
//  Entity.swift
//  relliK
//
//  Created by Andre Villanueva on 7/30/15.
//  Copyright © 2015 Bang Bang Studios. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Entity: SKSpriteNode {
    var health = 0
    var maxHealth = 0
    var hurtSoundString = String()
    var attackSoundString = String()
    var moveSoundString = String()
    var diedSoundString = String()
    var directionOf = entityDirection.unSelected
    var move: SKAction = SKAction()
    var entityCurrentBlock:blockPlace = blockPlace.unSelected
    var entityInRangeBlock:blockPlace = blockPlace.unSelected
    
    var isDead: Bool{
        return health < 1
    }
    
    init(position: CGPoint, texture: SKTexture) {
        
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())
        
        self.position = position
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
    
    func updateSpriteAtrributes(){
//        physicsBody = SKPhysicsBody(rectangleOfSize: size)
//        physicsBody?.categoryBitMask = PhysicsCategory.None
//        physicsBody?.contactTestBitMask = PhysicsCategory.None
//        physicsBody?.collisionBitMask = PhysicsCategory.None
//        physicsBody?.dynamic = false
    }
    
    func kill(){
        health = 0
        died()
    }
    
    func hurt(){
        --health
    }
    
    func moveToNextBlock(){
        
        switch entityCurrentBlock{
        case blockPlace.unSelected:
            entityCurrentBlock = blockPlace.fifth
        case blockPlace.fifth:
            entityCurrentBlock = blockPlace.fourth
        case blockPlace.fourth:
            entityCurrentBlock = blockPlace.third
        case blockPlace.third:
            entityCurrentBlock = blockPlace.second
        case blockPlace.second:
            entityCurrentBlock = blockPlace.first
        case blockPlace.first:
            entityCurrentBlock = blockPlace.home
        case blockPlace.home:
            return
        }
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
    
    func died(){
        if isDead{
            runAction(SKAction.removeFromParent())
        }
    }
}

