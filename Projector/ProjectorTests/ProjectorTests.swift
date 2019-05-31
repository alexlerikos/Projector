//
//  ProjectorTests.swift
//  ProjectorTests
//
//  Created by Alex Lerikos on 5/30/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import XCTest
@testable import Projector

class ProjectorTests: XCTestCase {
    
    
    var playbackStateMachine: PlaybackStateMachine!
    
    override func setUp() {
        self.playbackStateMachine = PlaybackStateMachine(dispatchQueue: DispatchQueue.main)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // State Machine Tests
    func testInitialState() {
        XCTAssertEqual(self.playbackStateMachine.stateMachine.currentState, .stopped)
    }
    
    func testTransitionCount() {
        XCTAssertEqual(self.playbackStateMachine.stateMachineTransitions().count, 8)
    }
    


}
