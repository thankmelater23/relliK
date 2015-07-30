  //
//  GlobalsAndConstants.swift
//  Color Wars
//
//  Created by Andre Villanueva on 6/3/15.
//  Copyright (c) 2015 BangBangStudios. All rights reserved.
//

import Foundation
import SpriteKit
  
  

  enum entityDirection{
    case left
    case right
    case up
    case down
    case unSelected
  }

  enum block: Int {
    case first
    case second
    case third
    case fourth
    case fifth
    case home
    case unSelected

  }

  enum blockLabel: Int{
    case empty
    case enemy
    case player
    case bullet
  }


  let GAME_MAX_SPEED:CGFloat = 0.5
  let GAME_MIN_SPEED:CGFloat = 3.0

  enum buttonReference:Int{
    case left1
    case left2
    case left3
    case left4
    case left5
    case Right1
    case Right2
    case Right3
    case Right4
    case Right5
    case up1
    case up2
    case up3
    case up4
    case up5
    case down1
    case down2
    case down3
    case down4
    case down5

    
  }

  let enemyWaitIncrementalSpeed: NSTimeInterval = -0.1
  let enemyWaitMinSpeed:NSTimeInterval = 0.5//Temporary here to get a better feel of game
  let enemyWaitMaxSpeed:NSTimeInterval = 0.3
  var enemyWaitTime:NSTimeInterval = enemyWaitMinSpeed

  var gameSpeed: NSTimeInterval = gameMinSpeed + enemyWaitTime
  let gameIncrementalSpeed: NSTimeInterval = 0.1
  let gameMinSpeed:NSTimeInterval = 1.0//Temporary here to get a better feel of game
  let gameMaxSpeed:NSTimeInterval = 0.5
  var enemySpawnSpeed: NSTimeInterval = 2.0
  let enemyIncrementalSpawnSpeed: NSTimeInterval = 0.1
  
  var spaceBetweenEnemyBlock: CGFloat  = 75.00
  var incrementalSpaceBetweenBlocks: CGFloat  = 70.00
  let playerScale: CGFloat  = 0.25
  let enemyScale: CGFloat  = 0.20
  let playerBlockScale: CGFloat  = 0.30
  let enemyBlockScale: CGFloat = 0.27
  let bulletScale:CGFloat = 0.35
  var bulletCoolDownTime:NSTimeInterval = gameMaxSpeed
  var bulletCurrentCoolDownTime: NSTimeInterval = NSTimeInterval(0.0)
  var lastShot: NSTimeInterval = NSTimeInterval(0.0)
  
  var spaceToLastBox: CGFloat = incrementalSpaceBetweenBlocks * 4
  
  

