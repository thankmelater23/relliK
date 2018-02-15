
//
//  MenuScene.swift
//  Amplitude-iOS
//
//  Created by Andre on 2/13/18.
//

import UIKit
import SpriteKit

class MenuScene : SKScene {
  let startButtonTexture = SKTexture(imageNamed: "button_start")
  let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed")
  let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
  let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")
  
  let logoSprite = SKSpriteNode(imageNamed: "logo")
  var startButton : SKSpriteNode! = nil
  var soundButton : SKSpriteNode! = nil
  
  let highScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
  
  var selectedButton : SKSpriteNode?
  
  override func sceneDidLoad() {
    backgroundColor = SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)
    
    //Set up logo - sprite initialized earlier
    logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
    
    addChild(logoSprite)
    
    //Set up start button
    startButton = SKSpriteNode(texture: startButtonTexture)
    startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - startButton.size.height / 2)
    
    addChild(startButton)
    
    let edgeMargin : CGFloat = 25
    
    //Set up sound button
    soundButton = SKSpriteNode(texture: soundButtonTexture)
    soundButton.position = CGPoint(x: size.width - soundButton.size.width / 2 - edgeMargin, y: soundButton.size.height / 2 + edgeMargin)
    
    addChild(soundButton)
    
    //Set up high-score node
    let defaults = UserDefaults.standard
    
    let highScore = defaults.integer(forKey: "high score")
    
    highScoreNode.text = "\(highScore)"
    highScoreNode.fontSize = 90
    highScoreNode.verticalAlignmentMode = .top
    highScoreNode.position = CGPoint(x: size.width / 2, y: startButton.position.y - startButton.size.height / 2 - 50)
    highScoreNode.zPosition = 1
    
    addChild(highScoreNode)
  }
}
