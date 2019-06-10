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
    var playbackButtonStateMachine: PlaybackButtonStateMachine!
    
    override func setUp() {
        self.playbackStateMachine = PlaybackStateMachine(dispatchQueue: DispatchQueue.main)
        self.playbackButtonStateMachine = PlaybackButtonStateMachine(dispatchQueue: DispatchQueue.main)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // State Machine Tests
    func testInitialState() {
        XCTAssertEqual(self.playbackStateMachine.stateMachine.currentState, .stopped)
    }
    
    func testPlaybackStateMachineTransitionCount() {
        XCTAssertEqual(self.playbackStateMachine.stateMachineTransitions().count, 10)
    }
    
    func testPlaybackButtonTransitionCount() {
        XCTAssertEqual(self.playbackButtonStateMachine.stateMachineTransitions().count, 5)
    }
    
    


}
