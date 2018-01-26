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

class Player: Entity {
    private static var __once: () = {
            // 2
            let mainPlayer = SKSpriteNode(imageNamed: "Spaceship")
            mainPlayer.name = "player"

            // 5
            let textureView = SKView()
            SharedTexture.texture = textureView.texture(from: mainPlayer)!
            SharedTexture.texture.filteringMode = .nearest
        }()
    init(entityPosition: CGPoint) {
        let entityTexture = Player.generateTexture()!

        super.init(position: entityPosition, texture: entityTexture)
        name = "player"
        setScale(playerScale)
        directionOf = entityDirection.down
        zPosition = 100.00
        updateSpriteAtrributes()
        setEntityTypeAttribures()
    }
    override class func generateTexture() -> SKTexture? {

        _ = Player.__once

        return SharedTexture.texture
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setAngle() {
        switch (directionOf) {
        case entityDirection.right:
            run(SKAction.rotate(toAngle: 2 * π, duration: TimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.left:
            run(SKAction.rotate(toAngle: π, duration: TimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.down:
            run(SKAction.rotate(toAngle: (3 / 2) + π, duration: TimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.up:
            run(SKAction.rotate(toAngle: π / 2, duration: TimeInterval(0.0), shortestUnitArc: true))
        case entityDirection.unSelected:
            //Dont run
            directionOf = entityDirection.unSelected
            print("direction unselected")
        }
    }
    override func updateSpriteAtrributes() {
        super.updateSpriteAtrributes()
        physicsBody = SKPhysicsBody(rectangleOf: (frame.size))
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    override func setEntityTypeAttribures() {
        maxHealth = 3
        health = maxHealth
        hurtSoundString = "playerPain1.wav"
        attackSoundString = "attack.wav"
        moveSoundString = "move.wav"
        diedSoundString = "died.wav"
        directionOf = entityDirection.unSelected
        entityCurrentBlock = blockPlace.unSelected
        entityInRangeBlock = blockPlace.fourth

        //childNodeWithName("bulletNode")
    }
    override func hurt() {
        super.hurt()
    }
}
