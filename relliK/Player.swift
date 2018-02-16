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
    let textureView = SKView()
    
    SharedTexture.texture = SKTexture.init(image: UIImage.init(named: imagesString.player)!)
      SharedTexture.texture.filteringMode = .nearest
  }()
  init(entityPosition: CGPoint) {
    var entityTexture = SKTexture()
      entityTexture = Player.generateTexture()!
    
//    GlobalRellikPlayerConcurrent.async(group: nil, qos: .userInteractive, flags: .barrier, execute: {[weak self] in
    super.init(position: entityPosition, texture: entityTexture)
    name = "player"
    setScale(playerScale)
    directionOf = entityDirection.down
    zPosition = 100.00
    updateSpriteAtrributes()
    setEntityTypeAttribures()
//  })
  }
  override class func generateTexture() -> SKTexture? {
    
    _ = Player.__once
    
    return SharedTexture.texture
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  internal override func setAngle() {
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
      log.verbose("direction unselected")
    }
  }
  override func updateSpriteAtrributes() {
    super.updateSpriteAtrributes()
    self.physicsBody = SKPhysicsBody(rectangleOf: (self.frame.size))
//    GlobalRellikPlayerConcurrent.async(group: nil, qos: .userInteractive, flags: .barrier, execute: {[weak self] in
      self.physicsBody?.usesPreciseCollisionDetection = true
      self.physicsBody?.categoryBitMask = PhysicsCategory.Player
      self.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
      self.physicsBody?.collisionBitMask = PhysicsCategory.None
//    })
  }
  override func setEntityTypeAttribures() {
    maxHealth = 3
    health = maxHealth
    hurtSoundString = "player hurt.wav"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "player died.wav"
    directionOf = entityDirection.unSelected
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.fourth
    self.flashRedEffect = hurtEffects()
    
    //childNodeWithName("bulletNode")
  }
  override func hurt() {
    run(SKAction.sequence([
      SKAction.colorize(
        with: SKColor.red,
        colorBlendFactor: 1.0,
        duration: 0.0),
      SKAction.wait(forDuration: 0.3), SKAction.run {
        super.hurt()
      }]))
  }
  
  override func died() {
    run(SKAction.sequence([
      SKAction.colorize(
        with: SKColor.red,
        colorBlendFactor: 1.0,
        duration: 0.0),
      SKAction.wait(forDuration: 0.3), SKAction.run {
        super.died()
        if self.isDead{fatalError()}
      }]))
  }
  deinit {
    log.verbose(#function)
    log.verbose(self)
  }
  
}
