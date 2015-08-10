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

  enum blockPlace: Int {
    case home = 1
    case first = 2
    case second = 3
    case third = 4
    case fourth = 5
    case fifth = 6
    case unSelected = 7
  }

  enum blockLabel: Int{
    case empty
    case enemy
    case player
    case bullet
  }
  
  struct PhysicsCategory {
    static let All: UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let Enemy: UInt32 = 0x1 << 2
    static let Bullet: UInt32 = 0x1 << 3
    static let dead: UInt32 = 0x1 << 30
    static let None: UInt32 = 0x1 << 29
  }
  
  struct BitMaskOfLighting {
    static let None: UInt32 = 0x1 << 0
    static let right: UInt32 = 0x1 << 1
    static let left: UInt32 = 0x1 << 2
    static let down: UInt32 = 0x1 << 3
    static let up: UInt32 = 0x1 << 4
  }


  let GAME_MAX_SPEED:NSTimeInterval = 0.3
  let GAME_MIN_SPEED:NSTimeInterval = 2.0
  
  //Scales
  let playerScale: CGFloat  = 0.10
  let enemyScale: CGFloat  = 0.10
  let playerBlockScale: CGFloat  = 0.20
  let enemyBlockScale: CGFloat = 0.12
  let bulletScale:CGFloat = 0.15

  //Sizes
  var spaceBetweenEnemyBlock: CGFloat  = 40.00
  var incrementalSpaceBetweenBlocks: CGFloat  = 30.00
  var spaceToLastBox: CGFloat = incrementalSpaceBetweenBlocks * 4

  var gameSpeed: NSTimeInterval = GAME_MIN_SPEED
  let gameIncrementalSpeed: NSTimeInterval = 0.20
//  var enemySpawnSpeed: NSTimeInterval = 2.0
//  let enemyIncrementalSpawnSpeed: NSTimeInterval = 0.1
  
  //Time Vars
  let enemyWaitIncrementalSpeed: NSTimeInterval = gameIncrementalSpeed * 2
  let enemyWaitMinSpeed:NSTimeInterval = 1.0
  let enemyWaitMaxSpeed:NSTimeInterval = 0.2
  var enemyWaitTime:NSTimeInterval = enemyWaitMinSpeed
  var bulletCoolDownTime:NSTimeInterval =  GAME_MAX_SPEED / NSTimeInterval(1.0)
  var bulletCurrentCoolDownTime: NSTimeInterval = bulletCoolDownTime
  var lastShot: NSTimeInterval = NSTimeInterval(0.0)
  
  
  
  
  
  
  

