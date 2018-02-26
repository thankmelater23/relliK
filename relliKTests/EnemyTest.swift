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
    var entity = Boss()

    override func setUp() {
        super.setUp()
        entity = Boss()
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
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testEnemyPerformanceTest() {
        measure {
            _ = Enemy()
        }
    }

    func testGhostPerformanceTest() {
        measure {
            _ = Ghost()
        }
    }

    func testSoldierPerformanceTest() {
        measure {
            _ = Soldier()
        }
    }

    func testBossPerformanceTest() {
        measure {
            _ = Boss()
        }
    }

    func testMinionPerformanceTest() {
        measure {
            _ = Minion()
        }
    }
}

extension EnemyTest {
    func testMovePerformance() {
        let entity = Boss()
        entity.directionOf = .down

        measure {
            entity.moveFunc()
        }
    }

    func testHurt() {
        measure {
            entity.hurt()
        }
    }

    func testMoveToNextBlock() {
        measure {
            entity.moveToNextBlock()
        }
    }

    func testUpdateSpriteAtrributes() {
        measure {
            entity.updateSpriteAtrributes()
        }
} }
