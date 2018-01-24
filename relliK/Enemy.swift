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
    createHealthBar()
    setEntityTypeAttribures()
    
  }
  func createHealthBar(){
    
    
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
  
  //Action Methods
  func moveFunc(){
    setAngle()
    move.timingMode = SKActionTimingMode.easeInEaseOut
    run(moveAction(), withKey: "move")
    print(gameSpeed)
    print(enemyWaitTime)
  }
  override func moveToNextBlock() {
    super.moveToNextBlock()
  }
  func moveAction() ->SKAction{
    defer{
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
    
    let moveSound = SKAction.playSoundFileNamed(moveSoundString, waitForCompletion: false)
    
    switch (directionOf){
    case entityDirection.left:
      let moveLeftAction = SKAction.moveBy(x: incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
      return SKAction.sequence([wait, moveToNextBlockAction, moveSound, moveLeftAction])
    case entityDirection.right:
      let moveRightAction = SKAction.moveBy(x: -incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed)
      
      return SKAction.sequence([wait, moveToNextBlockAction, moveSound, moveRightAction])
    case entityDirection.down:
      let moveDownAction = SKAction.moveBy(x: 0, y: incrementalSpaceBetweenBlocks, duration: gameSpeed)
      
      return SKAction.sequence([wait, moveToNextBlockAction, moveSound, moveDownAction])
    case entityDirection.up:
      let moveUpAction = SKAction.moveBy(x: 0, y: -incrementalSpaceBetweenBlocks, duration: gameSpeed)
      
      return SKAction.sequence([wait, moveToNextBlockAction, moveSound, moveUpAction])
    case entityDirection.unSelected:
      //Dont run
      print("direction unselected")
      assertionFailure("Entity direction was never sent, this should never happen")
      return SKAction()
    }
    
  }
  override func died(){
    super.died()
    //
    //        if isDead{
    //            let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    //            scoreLabel.name = "Show Score Points"
    //            scoreLabel.color = SKColor.redColor()
    //            scoreLabel.fontSize = 20
    //            scoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
    //            scoreLabel.text = String(sumForScore())
    //            scoreLabel.zPosition = 100
    //
    //            self.parent?.addChild(scoreLabel)
    //
    //            let action = SKAction.sequence([SKAction.scaleTo(0.0, duration: 0.5), SKAction.removeFromParent()])
    //
    //            scoreLabel.runAction(action)
    //        }
  }
  override func hurt(){
    super.hurt()
    
    let healthLabel = SKLabelNode(fontNamed: "Chalkduster")
    healthLabel.name = "Hurt Label"
    healthLabel.color = SKColor.red
    healthLabel.fontSize = 20
    healthLabel.position = CGPoint(x: frame.midX, y: frame.midY)
    healthLabel.text = String(health)
    healthLabel.zPosition = 100
    
    if health <= 0{
      healthLabel.fontColor = SKColor.red
    }else if health == 1{
      healthLabel.fontColor = SKColor.yellow
    }else{
      healthLabel.fontColor = SKColor.green
    }
    
    self.parent?.addChild(healthLabel)
    
    let action = SKAction.sequence([SKAction.scale(to: 0.0, duration: 0.5), SKAction.removeFromParent()])
    
    healthLabel.run(action)
  }
}

class Boss:Enemy{
  private static var __once: () = {
    // 2
    let enemy = SKSpriteNode(imageNamed: "enemy")
    
    //            healthLabel = SKLabelNode(fontNamed: "Chalkduster")
    //            healthLabel.fontSize = 100
    //            //healthLabel.alpha = 0.7
    //            healthLabel.fontColor = SKColor.greenColor()
    //            healthLabel.name = "healthLabel"
    //            //
    //            //healthLabel.zPosition = zPosition + 1
    //            var healthString: Int!
    ////            while var i <= healthString{
    ////                healthString++
    ////                i++
    ////            }
    //            healthLabel.text = String(healthString)
    //
    //
    //            healthLabel.position = CGPoint(x: 0.5, y: (enemy.texture?.size().height)!)// + (healthLabel.frame.size.height / 2))
    //            enemy.addChild(healthLabel)
    //            healthLabel.runAction(SKAction.rotateToAngle(π, duration: NSTimeInterval(0.0), shortestUnitArc: true))
    //
    
    // 5
    let textureView = SKView()
    SharedTexture.texture = textureView.texture(from: enemy)!
    SharedTexture.texture.filteringMode = .nearest
    SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)
  }()
  init(entityPosition: CGPoint) {
    let entityTexture = Boss.generateTexture()!
    
    super.init(texture: entityTexture)
    position = entityPosition
    name = "boss"
    setScale(enemyScale)
    directionOf = entityDirection.unSelected
    
  }
  override func setEntityTypeAttribures(){
    maxHealth = 3
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.fourth
    scoreValue = 15
    //Sound
    hurtSoundString = "bossHurt.wav"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "died.wav"
    //        directionOf = entityDirection.unSelected
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private static let onceToken = { () -> SKTexture in
    
    let enemy = SKSpriteNode(imageNamed: "enemy")
    enemy.name = "boss"
    
    let textureView = SKView()
    SharedTexture.texture = textureView.texture(from: enemy)!
    SharedTexture.texture.filteringMode = .nearest
    SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)
    
    return SharedTexture.texture
  }()
}

class Ghost:Enemy{
  init(entityPosition: CGPoint) {
    let entityTexture = Ghost.generateTexture()!
    
    super.init(texture: entityTexture)
    position = entityPosition
    name = "ghost"
    setScale(enemyScale)
    directionOf = entityDirection.unSelected
    //        alpha = 0.1
  }
  override func setEntityTypeAttribures(){
    maxHealth = 1
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.third
    scoreValue = 5
    //Sound
    hurtSoundString = "ghostHurt.wav"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "ghostHurt.wav"
    directionOf = entityDirection.unSelected
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private static let onceToken = { () -> SKTexture in
    
    let enemy = SKSpriteNode(imageNamed: "cat")
    enemy.name = "ghost"
    
    let textureView = SKView()
    SharedTexture.texture = textureView.texture(from: enemy)!
    SharedTexture.texture.filteringMode = .nearest
    SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)
    
    return SharedTexture.texture
  }()
}

class Soldier:Enemy{
  init(entityPosition: CGPoint) {
    
    let entityTexture = Soldier.generateTexture()!
    
    super.init(texture: entityTexture)
    
    position = entityPosition
    name = "soldier"
    setScale(enemyScale)
    directionOf = entityDirection.unSelected
  }
  override func setEntityTypeAttribures(){
    maxHealth = 2
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.second
    scoreValue = 10        //Sound
    hurtSoundString = "soldierHurt.wav"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "died.wav"
    //        directionOf = entityDirection.unSelected
    
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private static let onceToken = { () -> SKTexture in
    
    let enemy = SKSpriteNode(imageNamed: "zombie1")
    enemy.name = "soldier"
    
    let textureView = SKView()
    SharedTexture.texture = textureView.texture(from: enemy)!
    SharedTexture.texture.filteringMode = .nearest
    SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)
    
    return SharedTexture.texture
  }()
}

class Minion:Enemy{
  init(entityPosition: CGPoint) {
    
    let entityTexture = Minion.generateTexture()!
    
    super.init(texture: entityTexture)
    position = entityPosition
    name = "minion"
    setScale(enemyScale)
    directionOf = entityDirection.unSelected
  }
  override func setEntityTypeAttribures(){
    maxHealth = 1
    health = maxHealth
    entityCurrentBlock = blockPlace.unSelected
    entityInRangeBlock = blockPlace.fifth
    scoreValue = 5
    //Sound
    hurtSoundString = "minionHurt.wav"
    attackSoundString = "attack.wav"
    moveSoundString = "move.wav"
    diedSoundString = "died.wav"
    
  }
  override class func generateTexture() -> SKTexture? {
    
    return onceToken
  }
  
  private static let onceToken = { () -> SKTexture in
    
    let enemy = SKSpriteNode(imageNamed: "cat")
    enemy.name = "minion"
    enemy.color = UIColor.yellow
    
    let textureView = SKView()
    SharedTexture.texture = textureView.texture(from: enemy)!
    SharedTexture.texture.filteringMode = .nearest
    SharedTexture.texture.generatingNormalMap(withSmoothness: 0.6, contrast: 1.0)
    
    return SharedTexture.texture
  }()
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
