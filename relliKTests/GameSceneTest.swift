//
//  GameSceneTest.swift
//  relliKTests
//
//  Created by Andre on 2/1/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import XCTest
import SpriteKit

@testable import relliK

class GameSceneTest: XCTestCase {
  let scene = GameScene(size: CGSize(width: 2208, height: 1242))
  
  override func setUp() {
    super.setUp()
    scene.player = Player.init(entityPosition: CGPoint())
    scene.player.directionOf = .down
    scene.cpuEnabled = true
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
}

///MARK: -Performance test
extension GameSceneTest{
  func testPerformance() {
    self.measure {
      
    }
  }
  func testPerformanceCreatePlayer() {
    self.measure {
      scene.createPlayer()
      
    }
  }
  func testPerformanceCreatePlayerBlock() {
    self.measure {
      scene.createPlayerBlock()
    }
  }
//  func testPerformanceCreateSwipeRecognizers() {
//    self.measure {
//      scene.createSwipeRecognizers()
//    }
//  }
//  func testPerformanceDebugDrawPlayableArea() {
//    self.measure {
//      scene.debugDrawPlayableArea()
//    }
//  }
//  func testPerformanceDidMove() {
//    self.measure {
//      scene.didMove(to: SKView())
//    }
//  }
//  func testPerformanceGameOver() {
//    self.measure {
//      scene.gameOver()
//    }
//  }
//  func testPerformanceGameSceneInitializes() {
//    self.measure {
//      let _ = GameScene(size: CGSize(width: 2208, height: 1242))
//    }
//  }
  func testPerformanceLoadDefaults() {
    self.measure {
      scene.highScoreSetup()
    }
  }
  func testPerformanceMoveBullets() {
    self.measure {
      scene.moveBullets()
    }
  }
  func testPerformanceMoveEnemies() {
    self.measure {
      scene.moveEnemies()
    }
  }
  func testPerformanceParticleCreator() {
    self.measure {
      scene.particleCreator()
    }
  }
  func testPerformanceRandomEnemy() {
    self.measure {
      let enemy = scene.randomEnemy(CGPoint(), delegate: scene)
    }
  }
  func testPerformanceSetDebugLabels() {
    self.measure {
      scene.setDebugLabels()
    }
  }
//  func testPerformanceSetGameLights() {
//    self.measure {
//      scene.setGameLights()
//    }
//  }
  func testPerformanceSetLabels() {
    self.measure {
      scene.setLabels()
    }
  }
  func testPerformanceSetPhysics() {
    self.measure {
      scene.setPhysics()
    }
  }
  func testPerformanceSpawnEnemy() {
    self.measure {
      scene.spawnEnemy()
    }
  }
  func testPerformanceUpdate() {
    self.measure {
      scene.update(TimeInterval())
    }
  }
}
