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
  struct SharedTexture {
    static var texture = SKTexture()
  }
  var health = 0
  var maxHealth = 0
  var scoreValue = 0
  var clearedForMorgue = false
  var hurtSoundString = "hurt.wav"
  var attackSoundString = "attack.wav"
  var moveSoundString = "move.wav"
  var diedSoundString = "died.wav"
  var blockSoundString = "block.wav"
  var dodgeSoundString = "dodge.wav"
  var directionOf = entityDirection.unSelected {
    didSet{
      if self.directionOf != .unSelected{
      self.setAngle()
      }
    }
  }
  weak var move: SKAction? = SKAction()
  var entityCurrentBlock: blockPlace = blockPlace.unSelected
  var entityInRangeBlock: blockPlace = blockPlace.unSelected
  weak var flashRedEffect: SKAction?
//  var healthLabel: SKLabelNode = SKLabelNode()
  var isDead: Bool { return health < 1 }
  
  internal func setEntityTypeAttribures() {}
  func sumForScore() -> Int {
    var maximumPoints = 20
    var timeTillFill: TimeInterval = 0
    
    while(timeTillFill <= gameTotalSpeed) {
      timeTillFill += TimeInterval(0.10)
      maximumPoints -= 2
      if(maximumPoints < 0) {
        maximumPoints = 0
      }
    }
    
    let placeValue = (25 / entityCurrentBlock.rawValue)
    let total = maximumPoints + placeValue + scoreValue
    return total
    //position + score + game speed
    //place starting with enemy start = 5,4,3,4,5
    //gameTotalSpeed * 100
  }
  func isBlockPlaceMoreThanRange() -> Bool {
    return entityCurrentBlock.rawValue <= entityInRangeBlock.rawValue ? true : false
  }
  init(position: CGPoint, texture: SKTexture) {
    
    super.init(texture: texture, color: SKColor.white, size: texture.size())
    
    self.position = position
    hurtEffects()
    setEntityTypeAttribures()
  }
  func getSideForLighting() -> UInt32 {
    switch directionOf {
    case .right:
      return BitMaskOfLighting.right
    case .left:
      return BitMaskOfLighting.left
    case .up:
      return BitMaskOfLighting.up
    case .down:
      return BitMaskOfLighting.down
    case .unSelected:
      return BitMaskOfLighting.None
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  class func generateTexture() -> SKTexture? {
    // Overridden by subclasses
    return nil
  }
  func update(_ delta: TimeInterval) {
    // Overridden by subclasses
  }
  func updateSpriteAtrributes() {
  }
  func kill() {
    health = 0
    died()
  }
  func hurt() {
    health -= 1
    healthLabel()
    if let flash = flashRedEffect {
      run(flash)
    }else{ log.warning("Hurt flash not initialized")}
    died()
  }
  func moveToNextBlock() {
    
    switch entityCurrentBlock {
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
   func setAngle() {
    switch (directionOf) {
    case entityDirection.left:
      run(SKAction.rotate(toAngle: 2 * π, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.right:
      run(SKAction.rotate(toAngle: π, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.up:
      run(SKAction.rotate(toAngle: (3 / 2) + π, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.down:
      run(SKAction.rotate(toAngle: π / 2, duration: TimeInterval(0.0), shortestUnitArc: true))
    case entityDirection.unSelected:
      return
    }
  }
  func died() {
    if isDead {//If dead turns sprite red waits for x seconds and then removes the sprite from parent
      playDeadSound()
      physicsBody?.categoryBitMask = PhysicsCategory.dead//Stops all contact and collision detection after death
      self.removeAllActions()
      self.removeAllChildren()
      self.removeFromParent()
      self.removeAllActions()
//      self.texture = nil
    }
  }
  func hurtEffects() {
//    GlobalRellikSerial.async {
      let colorizeSpriteToRed = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.5)
      let colorizeSpriteToNorm = SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.0, duration: 0.5)
      let ColorOnOfSprite = SKAction.sequence([colorizeSpriteToRed, colorizeSpriteToNorm])
      let ColorsGoing = SKAction.repeat(ColorOnOfSprite, count: 2)
      let fadeOut: SKAction = SKAction.fadeOut(withDuration: 0.25)
      let fadeIn: SKAction = SKAction.reversed(fadeOut)()
      let twinkleTwincle = SKAction.sequence([fadeOut, fadeIn])
      let flash = SKAction.repeat(twinkleTwincle, count: 4)
      
        let groupAction = SKAction.group([flash, ColorsGoing])
        self.flashRedEffect = groupAction
//    }
  }
  func healthLabel(){
        let healthLabel = SKLabelNode(fontNamed: "Chalkduster")
        healthLabel.name = "Hurt Label"
        healthLabel.color = SKColor.red
        healthLabel.fontSize = 30
        healthLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        healthLabel.text = String(health)
        healthLabel.zPosition = 100
    
        if health <= 0 {
            healthLabel.fontColor = SKColor.red
          } else if health == 1 {
            healthLabel.fontColor = SKColor.yellow
          } else {
            healthLabel.fontColor = SKColor.green
          }
    
        self.parent?.addChild(healthLabel)
    
        let action = SKAction.sequence([SKAction.scale(to: 0.0, duration: 0.5), SKAction.removeFromParent()])
      
          healthLabel.run(action)
  }
  deinit {
//    log.verbose(#function)
  }
  //Sounds
  func playSoundEffect(_ fileName: String) {
//    GlobalRellikSFXConcurrent.async {[weak self] in
      self.run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
//    }
  }
  func playDeadSound() {
    playSoundEffect(diedSoundString)
  }
  func playHurtSound() {
    playSoundEffect(hurtSoundString)
  }
  func playattackSound() {
    playSoundEffect(attackSoundString)
  }
  func playMoveSound() {
    playSoundEffect(moveSoundString)
  }
  func playDodgeSound() {
    playSoundEffect(dodgeSoundString)
  }
  func playBlockSound() {
    playSoundEffect(blockSoundString)
  }
}
