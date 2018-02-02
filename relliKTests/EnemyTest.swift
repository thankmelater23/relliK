//
//  EnemyTest.swift
//  relliKTests
//
//  Created by Andre on 2/1/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import XCTest
import SpriteKit
@testable import relliK

class EnemyTest: XCTestCase {
  var entity = Boss.init()
  
  override func setUp() {
    super.setUp()
    entity = Boss.init()
    entity.directionOf = .down
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
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testEnemyPerformanceTest(){
    self.measure {
      let _ = Enemy.init()
    }
  }
  
  func testGhostPerformanceTest(){
    self.measure {
      let _ = Ghost.init()
    }
  }
  
  func testSoldierPerformanceTest(){
    self.measure {
      let _ = Soldier.init()
    }
  }
  
  func testBossPerformanceTest(){
    self.measure {
      let _ = Boss.init()
    }
  }
  
  func testMinionPerformanceTest(){
    self.measure {
      let _ = Minion.init()
    }
  }
  
}

extension EnemyTest{
  func testMovePerformance(){
    let entity = Boss.init()
    entity.directionOf = .down
    
    self.measure {
      entity.moveFunc()
    }
  }
  
  func testHurt(){
    self.measure {
      entity.hurt()
    }
  }
  func testMoveToNextBlock(){
    self.measure {
      entity.moveToNextBlock()
    }
  }
  func testUpdateSpriteAtrributes(){
    self.measure {
      entity.updateSpriteAtrributes()
    }
  }}
