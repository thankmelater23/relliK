//
//  EnemyTest.swift
//  relliKTests
//
//  Created by Andre on 2/1/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import XCTest
@testable import relliK

class EnemyTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
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
      let enemy = Enemy.init(coder: NSCoder())
    }
  }
  
  func testGhostPerformanceTest(){
    self.measure {
      let ghost = Ghost.init(entityPosition: CGPoint())
    }
  }
  
  func testSoldierPerformanceTest(){
    self.measure {
      let soldier = Soldier.init(entityPosition: CGPoint())
    }
  }
  
  func testBossPerformanceTest(){
    self.measure {
      let boss = Boss.init(entityPosition: CGPoint())
    }
  }
  
  func testMinionPerformanceTest(){
    self.measure {
      let minion = Minion.init(entityPosition: CGPoint())
    }
  }
  
}
