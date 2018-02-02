//
//  Structures.swift
//  relliK
//
//  Created by Andre on 1/26/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import Foundation


struct imagesString{
  static let player = "player arms-out"
  static let Boss = "marshmello"
  static let enemy1 = "zombie1"
  static let enemy2 = "enemy"
  static let enemy3 = "cartoon-zombie"
  static let engine = "engine"
}

enum GameState{
  case mainMenu, loading, playing, gameOver, paused
}
