//
//  GlobalsAndConstants.swift
//  Color Wars
//
//  Created by Andre Villanueva on 6/3/15.
//  Copyright (c) 2015 BangBangStudios. All rights reserved.
//

import Foundation
import SpriteKit

/// Amount of seconds in a day 86,400
let SecondsInADay = 86400

  enum entityDirection {
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

  enum blockLabel: Int {
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

  let GAME_MIN_SPEED: TimeInterval = TimeInterval(1.0)
  let GAME_MAX_SPEED: TimeInterval = TimeInterval(0.5)
  let enemyWaitMinSpeed: TimeInterval = TimeInterval(1.0)
  let enemyWaitMaxSpeed: TimeInterval = TimeInterval(0.1)

  //Scales
  let playerScale: CGFloat  = 0.35
  let enemyScale: CGFloat  = 0.20
  let playerBlockScale: CGFloat  = 0.35
  let enemyBlockScale: CGFloat = 0.25
  let bulletScale: CGFloat = 0.40

  //Sizes
///Space between blocks and character
  var spaceBetweenEnemyBlock: CGFloat  = 85.00
///Space between each block
  var incrementalSpaceBetweenBlocks: CGFloat  = 55.00
  var spaceToLastBox: CGFloat = incrementalSpaceBetweenBlocks * 4

  var gameSpeed: TimeInterval = GAME_MIN_SPEED
  let gameIncrementalSpeed: TimeInterval = (GAME_MIN_SPEED - GAME_MAX_SPEED) * 0.10 //GAME_MIN_SPEED / NSTimeInterval(4.0)

  //Time Vars
  let enemyWaitIncrementalSpeed: TimeInterval = (enemyWaitMinSpeed - enemyWaitMaxSpeed) * 0.10 //gameIncrementalSpeed * 2  //enemyWaitMinSpeed / NSTimeInterval(4.0)
  var enemyWaitTime: TimeInterval = enemyWaitMinSpeed
  var bulletCoolDownTime: TimeInterval =  0.1 //GAME_MAX_SPEED
  var bulletCurrentCoolDownTime: TimeInterval = bulletCoolDownTime
  var lastShot: TimeInterval = TimeInterval(0.0)

  var gameTotalSpeed: TimeInterval = gameSpeed + enemyWaitTime

/// String thats used for sharing feature
let ShareLink = """
**************************************
Check out relliK #App for your Apple Device. Download it #FREE today!***CLICK THE LINK***
**************************************
#2DGame #Shooter #Arcade #2018 #IOSApp #BangBangStudios #relliK
**************************************
http://BangBangStudios.com/relliK
"""

  // MARK: - GCD
  /// First, the system provides you with a special serial queue known as the main queue. Like any serial queue, tasks in this queue execute one at a time. However, it’s guaranteed that all tasks will execute on the main thread, which is the only thread allowed to update your UI. This queue is the one to use for sending messages to UIView objects or posting notifications.
  let GlobalMainQueue = DispatchQueue.main
  /// QOS_CLASS_USER_INTERACTIVE: The user interactive class represents tasks that need to be done immediately in order to provide a nice user experience. Use it for UI updates, event handling and small workloads that require low latency. The total amount of work done in this class during the execution of your app should be small.
  let GlobalUserInteractiveQueue = DispatchQueue(label: "com.userInteractive", qos: .userInteractive, attributes: DispatchQueue.Attributes.concurrent)
  /// QOS_CLASS_USER_INITIATED: The user initiated class represents tasks that are initiated from the UI and can be performed asynchronously. It should be used when the user is waiting for immediate results, and for tasks required to continue user interaction.
  let GlobalUserInitiatedQueue = DispatchQueue(label: "com.userInitiated", qos: .userInitiated, attributes: .concurrent)
  /// QOS_CLASS_UTILITY: The utility class represents long-running tasks, typically with a user-visible progress indicator. Use it for computations, I/O, networking, continous data feeds and similar tasks. This class is designed to be energy efficient.
  let GlobalUtilityQueue = DispatchQueue(label: "com.Utility", qos: .utility, attributes: .concurrent)
  /// QOS_CLASS_BACKGROUND: The background class represents tasks that the user is not directly aware of. Use it for prefetching, maintenance, and other tasks that don’t require user interaction and aren’t time-sensitive.
  let GlobalBackgroundQueue = DispatchQueue(label: "com.background", qos: .background, attributes: .concurrent)
  /// Custom concurrent Belize Lottery Background Queue
  let GlobalRellikConcurrent = DispatchQueue(label: "com.Rellik.Concurrent", attributes: .concurrent)
  /// Custom serial Belize Lottery Background Queue
  let GlobalRellikSerial = DispatchQueue(label: "com.Rellik.Serial")
  /// Custom Serial Belize Lottery Background DataTransform Queue
  let GlobalRellikDataTransformSerial = DispatchQueue(label: "com.Rellik.Serial.DataTransform")
  /// Custom Serial Belize Lottery Background Database Queue
  let GlobalRellikDataBaseSerial = DispatchQueue(label: "com.Rellik.Serial.DataBase")
  /// Custom Serial Belize Lottery Background Network Queue
  let GlobalRellikNetworkSerial = DispatchQueue(label: "com.Rellik.Serial.Network")
  /// Custom Serial Belize Lottery Background Network Queue
  let GlobalRellikSFXConcurrent      = DispatchQueue(label: "com.Rellik.Concurrent.Network", qos: .userInitiated, attributes: .concurrent)
  let GlobalRellikGameLoopConcurrent = DispatchQueue(label: "com.Rellik.Concurrent.GameLoop", qos: .userInitiated, attributes: .concurrent)
  let GlobalRellikGameLoopSerial     = DispatchQueue(label: "com.Rellik.Serial.GameLoop")
  let GlobalRellikBulletConcurrent   = DispatchQueue(label: "com.Rellik.Concurrent.Bullet", qos: .userInitiated, attributes: .concurrent)
  let GlobalRellikBulletSerial       = DispatchQueue(label: "com.Rellik.Serial.Bullet")
  let GlobalRellikEnemyConcurrent    = DispatchQueue(label: "com.Rellik.Concurrent.Enemy", qos: .userInitiated, attributes: .concurrent)
  let GlobalRellikEnemySerial        = DispatchQueue(label: "com.Rellik.Serial.Enemy")
  let GlobalRellikPlayerConcurrent   = DispatchQueue(label: "com.Rellik.Concurrent.Player", qos: .userInitiated, attributes: .concurrent)
  let GlobalRellikPlayerSerial       = DispatchQueue(label: "com.Rellik.Serial.Player")
///MARK: - Dispatch Groups
let GameLoadGroup = DispatchGroup()

