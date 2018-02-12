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
  weak var delegate: SceneUpdateProtocol? = nil
  
  //Initializars
  init(texture: SKTexture) {
    super.init(position: CGPoint(), texture: texture)
    self.directionOf = entityDirection.unSelected
    self.size = texture.size()
    self.setScale(enemyScale)
    self.zPosition = 90.00
    self.updateSpriteAtrributes()
    self.createHealthBar()
    self.setEntityTypeAttribures()
  }
  
  init(texture: SKTexture, delegate: SceneUpdateProtocol) {
    super.init(position: CGPoint(), texture: texture)
    self.directionOf = entityDirection.unSelected
    self.size = texture.size()
    self.setScale(enemyScale)
    self.zPosition = 90.00
    self.updateSpriteAtrributes()
    self.createHealthBar()
    self.setEntityTypeAttribures()
        self.delegate = delegate
  }
  
  convenience init(){
    self.init(texture: SKTexture())
  }
  func createHealthBar() {
    
  }
  func loadedEnemySettings() {//Turns on Lighting and shadowing
    //        lightingBitMask = super.getSideForLighting()
    //        shadowedBitMask = super.getSideForLighting()
  }
  override func updateSpriteAtrributes() {
    super.updateSpriteAtrributes()
    physicsBody = SKPhysicsBody(rectangleOf: (frame.size))
    physicsBody?.usesPreciseCollisionDetection = true
    physicsBody?.categoryBitMask = PhysicsCategory.Enemy
    physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
    physicsBody?.collisionBitMask = PhysicsCategory.None
    
    loadedEnemySettings()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  deinit {
//    log.verbose(#function)
//    log.verbose(self)
    delegate?.killCountUpdate!()
    delegate?.pointCountUpdate!(points: self.sumForScore())
    
  }
  
  //Action Methods
  func moveFunc() {
//    setAngle()
    move?.timingMode = SKActionTimingMode.easeInEaseOut
    
    run(moveAction(), withKey: "move")
//    log.verbose(gameSpeed)
//    log.verbose(enemyWaitTime)
  }
  override func moveToNextBlock() {
    super.moveToNextBlock()
  }
  func moveAction() -> SKAction {
    defer {
      loadedEnemySettings()
    }
    
    let wait = SKAction.wait(forDuration: enemyWaitTime)
    
    let moveToNextBlockAction = SKAction.run({ //node in
      self.moveToNextBlock()
      
      //            if self.name == "ghost"{//Fades the ghost to alpha 1
      //                if self.isBlockPlaceMoreThanRange(){
      //                    self.runAction(SKAction.fadeInWithDuration(0.0))
      //                }
      //            }
    })
    
    
    switch (directionOf) {
    case entityDirection.left:
      let moveLeftAction = SKAction.moveBy(x: incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
      return SKAction.sequence([wait, moveToNextBlockAction, moveLeftAction])
    case entityDirection.right:
      let moveRightAction = SKAction.moveBy(x: -incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
      return SKAction.sequence([wait, moveToNextBlockAction, moveRightAction])
    case entityDirection.down:
      let moveDownAction = SKAction.moveBy(x: 0, y: incrementalSpaceBetweenBlocks, duration: gameSpeed)
      return SKAction.sequence([wait, moveToNextBlockAction, moveDownAction])
    case entityDirection.up:
      let moveUpAction = SKAction.moveBy(x: 0, y: -incrementalSpaceBetweenBlocks, duration: gameSpeed)
      return SKAction.sequence([wait, moveToNextBlockAction, moveUpAction])
    case entityDirection.unSelected:
      //Dont run
      log.verbose("direction unselected")
      assertionFailure("Entity direction was never sent, this should never happen")
      return SKAction()
    }
    
  }
  override func died() {
    if self.isDead{
        super.died()
        self.clearedForMorgue = true
      
    }
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
}

class Boss: Enemy {
  init(entityPosition: CGPoint, delegate: SceneUpdateProtocol) {
    var entityTexture = SKTexture()
    GlobalRellikSerial.sync {
      entityTexture = Boss.generateTexture()!
    }
    super.init(texture: entityTexture)
    self.position = entityPosition
    self.name = "boss"
    self.setScale(enemyScale)
    self.directionOf = entityDirection.unSelected
    self.delegate = delegate
  }
  
  init(entityPosition: CGPoint) {
    var entityTexture = SKTexture()
    GlobalRellikSerial.sync {
      entityTexture = Boss.generateTexture()!
    }
      super.init(texture: entityTexture)
      self.position = entityPosition
      self.name = "boss"
      self.setScale(enemyScale)
      self.directionOf = entityDirection.unSelected
  }
  convenience init(){
    self.init(entityPosition: CGPoint())
  }
  override func setEntityTypeAttribures() {
    maxHealth = 3
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.fourth
    scoreValue = 15
    //Sound
    hurtSoundString = "bossHurt.wav"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "boss died.wav"
    //        directionOf = entityDirection.unSelected
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private static let onceToken = { () -> SKTexture in
    let textureView = SKView()
    
    SharedTexture.texture = SKTexture.init(image: UIImage.init(named: imagesString.Boss)!)
      SharedTexture.texture.filteringMode = .nearest
      //SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)

    return SharedTexture.texture
  }()
}

class Ghost: Enemy {
  init(entityPosition: CGPoint, delegate: SceneUpdateProtocol) {
    var entityTexture = SKTexture()
    GlobalRellikSerial.sync {
      entityTexture = Ghost.generateTexture()!
    }
    super.init(texture: entityTexture)
    self.position = entityPosition
    self.name = "ghost"
    self.setScale(enemyScale)
    self.directionOf = entityDirection.unSelected
    self.delegate = delegate
  }
  init(entityPosition: CGPoint) {
    var entityTexture = SKTexture()
    GlobalRellikSerial.sync {
      entityTexture = Ghost.generateTexture()!
    }
      super.init(texture: entityTexture)
      self.position = entityPosition
      self.name = "ghost"
      self.setScale(enemyScale)
      self.directionOf = entityDirection.unSelected
  }
  convenience init(){
    self.init(entityPosition: CGPoint())
  }
  
  override func setEntityTypeAttribures() {
    maxHealth = 1
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.third
    scoreValue = 5
    //Sound
    hurtSoundString = "zombie pain.wav"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "zombie dying.wav"
    directionOf = entityDirection.unSelected
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private static let onceToken = { () -> SKTexture in
    let textureView = SKView()
    
    SharedTexture.texture = SKTexture.init(image: UIImage.init(named: imagesString.enemy3)!)
      SharedTexture.texture.filteringMode = .nearest
      //SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)
    
    return SharedTexture.texture
    
  }()
}

class Soldier: Enemy {
  init(entityPosition: CGPoint, delegate: SceneUpdateProtocol) {
    var entityTexture = SKTexture()
    GlobalRellikSerial.sync {
      entityTexture = Soldier.generateTexture()!
    }
    super.init(texture: entityTexture)
    
    self.position = entityPosition
    self.name = "soldier"
    self.setScale(enemyScale)
    self.directionOf = entityDirection.unSelected
    self.delegate = delegate
  }
  
  init(entityPosition: CGPoint) {
    var entityTexture = SKTexture()
    GlobalRellikSerial.sync {
      entityTexture = Soldier.generateTexture()!
    }
      super.init(texture: entityTexture)
      
      self.position = entityPosition
      self.name = "soldier"
      self.setScale(enemyScale)
      self.directionOf = entityDirection.unSelected
  }
  
  convenience init(){
    self.init(entityPosition: CGPoint())
  }
  override func setEntityTypeAttribures() {
    maxHealth = 2
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.second
    scoreValue = 10        //Sound
    hurtSoundString = "zombie pain"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "zombie dying.wav"
    //        directionOf = entityDirection.unSelected
    
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private static let onceToken = { () -> SKTexture in
    let textureView = SKView()
    
    SharedTexture.texture = SKTexture.init(image: UIImage.init(named: imagesString.enemy2)!)
      SharedTexture.texture.filteringMode = .nearest
      //SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)

    return SharedTexture.texture
  }()
}

class Minion: Enemy {
  init(entityPosition: CGPoint, delegate: SceneUpdateProtocol) {
    var entityTexture = SKTexture()
    
    GlobalRellikSerial.sync {
      entityTexture = Minion.generateTexture()!
    }
    super.init(texture: entityTexture)
    self.position = entityPosition
    self.name = "minion"
    self.setScale(enemyScale)
    self.directionOf = entityDirection.unSelected
    self.delegate = delegate
  }
  
  init(entityPosition: CGPoint) {
    var entityTexture = SKTexture()
    
    GlobalRellikSerial.sync {
      entityTexture = Minion.generateTexture()!
    }
      super.init(texture: entityTexture)
      self.position = entityPosition
      self.name = "minion"
      self.setScale(enemyScale)
      self.directionOf = entityDirection.unSelected
  }
  
  convenience init(){
    self.init(entityPosition: CGPoint())
  }
  
  override func setEntityTypeAttribures() {
    maxHealth = 1
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.fifth
    scoreValue = 5
    //Sound
    hurtSoundString = "zombie pain"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "zombie dying.wav"
    
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private static let onceToken = { () -> SKTexture in
    let textureView = SKView()
    
    SharedTexture.texture = SKTexture.init(image: UIImage.init(named: imagesString.enemy1)!)
    SharedTexture.texture.filteringMode = .nearest
    //SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)
    
    return SharedTexture.texture
  }()
}
