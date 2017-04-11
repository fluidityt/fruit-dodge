//
//  NinjaTests.swift
//  NinjaTests
//
//  Created by Chris Pelling on 02/09/2016.
//  Copyright © 2016 Compelling. All rights reserved.
//

import XCTest
@testable import Ninja

class NinjaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecreaseLives() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let player = Player()
        
        player.decreaseLives()
        
        XCTAssertEqual(player.lives, 2)
    }
    
    func testDefeated() {
        let player = Player()
        
        player.kill()
        
        //XCTAssertEqual( NSStringFromClass(player.state.currentState), NSStringFromClass(Defeated))
    }
    
    func testPreloadAtlases()
    {
        TextureLoader.preloadTextures()
        TextureLoader.outputAtlases()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
