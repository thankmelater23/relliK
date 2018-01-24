//
//  Bullet.swift
//  relliK
//
//  Created by Andre on 1/24/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Bullet: Entity{
  init(entityPosition: CGPoint) {
    let entityTexture = Bullet.generateTexture()!
    super.init(position: entityPosition, texture: entityTexture)
    
    color = SKColor.black
    self.zPosition = CGFloat(90.00)
    self.setScale(bulletScale)
    let shot = SKEmitterNode(fileNamed: "engine")
    shot?.position = CGPoint(x: 0.5, y: 1.0)
    updateSpriteAtrributes()
    addChild(shot!)
    
    
    light.position = CGPoint(x: 0.5, y: 0.5)
    light.categoryBitMask = getSideForLighting()
    light.isEnabled = true
    light.lightColor = SKColor(red: 0, green: 0, blue: 200, alpha: 1.0)
    light.shadowColor = SKColor.black// SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    light.ambientColor = SKColor(red: 0, green: 0, blue: 200, alpha: 0.1)
    light.falloff = 1.0
    addChild(light)
  }
  override func setEntityTypeAttribures(){
    maxHealth = 1
    health = maxHealth
    hurtSoundString = "bulletHurt.wav"
    attackSoundString = "bulletAttack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "died.wav"
    directionOf = entityDirection.unSelected
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.fourth
    
    //childNodeWithName("bulletNode")
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
    private static let onceToken = { () ->
      SKTexture in
    
    let bullet = SKSpriteNode(imageNamed: "rainDrop")
    bullet.name = "bullet"
    bullet.alpha = 0.0
    
    let textureView = SKView()
    SharedTexture.texture = textureView.texture(from: bullet)!
    SharedTexture.texture.filteringMode = .nearest
    
      return SharedTexture.texture
  }()
  var outOfBoundsSoundString = "error.wav"
  var light = SKLightNode()
  var isShot = false
  var stopped = false{
    willSet{
      playOutOfBoundsError()
      
    }
  }
  override func setAngle(){
    switch (directionOf){
    case entityDirection.right:
      self.run(SKAction.rotate(toAngle: 2 * π , duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.left:
      self.run(SKAction.rotate(toAngle: π, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.down:
      self.run(SKAction.rotate(toAngle: (3 / 2) + π , duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.up:
      self.run(SKAction.rotate(toAngle: π / 2 , duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.unSelected:
      //Dont run
      directionOf = entityDirection.unSelected
      print("direction unselected")
    }
  }
  func moveFunc(){//Sets Angle, moves sprite an then removesSpriteFromParent
    setAngle()
    getSideForLighting()
    playattackSound()
    
    let action = SKAction.sequence([move, SKAction.run({ self.stopped = true}), SKAction.removeFromParent()])
    run(action, withKey: "move")
    
    isShot = true
  }
  override func updateSpriteAtrributes() {
    super.updateSpriteAtrributes()
    physicsBody = SKPhysicsBody(rectangleOf: (frame.size))
    physicsBody?.usesPreciseCollisionDetection = true
    physicsBody?.categoryBitMask = PhysicsCategory.Bullet
    physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
    physicsBody?.collisionBitMask = PhysicsCategory.None
  }
  override func died() {
    if isDead{//If dead turns sprite red waits for x seconds and then removes the sprite from parent
      physicsBody?.categoryBitMask = PhysicsCategory.dead//Stops all contact and collision detection after death
      run(SKAction.removeFromParent())
      //hurtSoundString = "bulletHurt.wav"
      self.playHurtSound()
    }
  }
  func playOutOfBoundsError(){
    playSoundEffect(outOfBoundsSoundString)
  }
}

