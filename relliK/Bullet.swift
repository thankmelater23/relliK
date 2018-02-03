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

class Bullet: Entity {
  var outOfBoundsSoundString = "error.wav"
  var light = SKLightNode()
  var isShot = false
  var stopped = false {
    willSet {
      playOutOfBoundsError()
      
    }
  }
  
  init(entityPosition: CGPoint) {
    var entityTexture = SKTexture()
    GlobalRellikSerial.sync {
      entityTexture = Bullet.generateTexture()!
    }
    
    
    super.init(position: entityPosition, texture: entityTexture)
    
    color = SKColor.black
    self.zPosition = CGFloat(90.00)
    self.setScale(bulletScale)
    
    GlobalRellikSerial.async {[weak self] in
      let shot = SKEmitterNode(fileNamed: imagesString.engine)
      shot?.position = CGPoint(x: 0.5, y: 1.0)
      self?.updateSpriteAtrributes()
      self?.addChild(shot!)
      
//      self.light.position = CGPoint(x: 0.5, y: 0.5)
//      self.light.categoryBitMask = self.getSideForLighting()
//      self.light.isEnabled = true
//      self.light.lightColor = SKColor(red: 0, green: 0, blue: 200, alpha: 1.0)
//      self.light.shadowColor = SKColor.black// SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
//      self.light.ambientColor = SKColor(red: 0, green: 0, blue: 200, alpha: 0.1)
//      self.light.falloff = 1.0
//      self.addChild(self.light)
    }
  }
  override func setEntityTypeAttribures() {
    super.setEntityTypeAttribures()
        GlobalRellikConcurrent.sync {[weak self] in
          self?.maxHealth = 1
          self?.health = (self?.maxHealth)!
    self?.hurtSoundString = "bulletHurt.wav"
    self?.attackSoundString = "bulletAttack.wav"
    self?.moveSoundString = "move.wav"
    self?.diedSoundString = "died.wav"
    self?.directionOf = entityDirection.unSelected
    self?.entityCurrentBlock = blockPlace.unSelected
    self?.entityInRangeBlock = blockPlace.fourth
    
    //childNodeWithName("bulletNode")
        }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  deinit {
    print(#function)
    print(self)
  }
  override func setAngle() {
    switch (directionOf) {
    case entityDirection.right:
      self.run(SKAction.rotate(toAngle: 2 * π, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.left:
      self.run(SKAction.rotate(toAngle: π, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.down:
      self.run(SKAction.rotate(toAngle: (3 / 2) + π, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.up:
      self.run(SKAction.rotate(toAngle: π / 2, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.unSelected:
      //Dont run
      directionOf = entityDirection.unSelected
      print("direction unselected")
    }
  }
  func moveFunc() {//Sets Angle, moves sprite an then removesSpriteFromParent
    let group = DispatchGroup()
    
    GlobalRellikConcurrent.async {[weak self] in
      group.enter()
      self?.setAngle()
      //    self.getSideForLighting()
      self?.playattackSound()
      
      let action = SKAction.sequence([(self?.move)!, SKAction.run({ self?.stopped = true}), SKAction.removeFromParent()])
      group.leave()
      
      group.notify(queue: GlobalRellikConcurrent){[weak self] in
        self?.run(action, withKey: "move")
        self?.isShot = true
      }
    }
  }
  override func updateSpriteAtrributes() {
    super.updateSpriteAtrributes()
    GlobalUserInitiatedQueue.sync{[weak self] in
      self?.physicsBody = SKPhysicsBody(rectangleOf: (self?.frame.size)!)
      self?.physicsBody?.usesPreciseCollisionDetection = true
      self?.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
      self?.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
      self?.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
  }
  override func died() {
    if isDead {//If dead turns sprite red waits for x seconds and then removes the sprite from parent
      physicsBody?.categoryBitMask = PhysicsCategory.dead//Stops all contact and collision detection after death
      run(SKAction.removeFromParent(), completion: {[weak self] in
        self?.removeAllActions()
        self?.removeAllActions()
        self = nil
      })
      
      self.playHurtSound()
    }
  }
  func playOutOfBoundsError() {
    playSoundEffect(outOfBoundsSoundString)
  }
  private static let onceToken = { () ->
    SKTexture in
    
//    //      GlobalRellikSerial.async {
//    let bullet = SKSpriteNode(imageNamed: "rainDrop")
//    bullet.name = "bullet"
//    bullet.alpha = 0.0
    
    let textureView = SKView()
    SharedTexture.texture = SKTexture.init(image: UIImage.init(named: imagesString.rainDrop)!)
    SharedTexture.texture.filteringMode = .nearest
    //      }
    return SharedTexture.texture
  }()

}
