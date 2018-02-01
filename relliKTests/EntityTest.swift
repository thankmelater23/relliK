//
//  EntityTest.swift
//  relliKTests
//
//  Created by Andre on 2/1/18.
//  Copyright © 2018 Bang Bang Studios. All rights reserved.
//

import XCTest
import SpriteKit

@testable import relliK

class EntityTest: XCTestCase {
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
  
}
///MARK: -Performance test
extension EntityTest{
  func testPerformance() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testPerformanceDied() {
    self.measure {
      entity.died()
    }
  }
  
  
  func testPerformanceGetSideForLighting() {
    self.measure {
      let _ = entity.getSideForLighting()
    }
  }
  
  func testPerformanceDidMoveToNextBlock() {
    self.measure {
      entity.moveToNextBlock()
    }
  }
  
  
  func testPerformancePlaySoundEffect() {
    self.measure {
      entity.playattackSound()
    }
  }
  
  
  func testPerformanceSetAngle() {
    self.measure {
      entity.setAngle()
    }
  }
  
  
  
  func testPerformanceSetEntityTypeAttributes() {
    self.measure {
      entity.setEntityTypeAttribures()
    }
  }
  
  func testPerformanceHurtEffects() {
    self.measure {
      entity.hurtEffects()
    }
  }
  
  
}
