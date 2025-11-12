//
//  PlaybackState.swift
//  Projector
//
//  Created by Alex Lerikos on 5/30/19.
//  Copyright © 2019 UhuApps. All rights reserved.
//

import UIKit

class PlaybackStateMachine: NSObject, StateMachineDelegate {
    let dispatchQueue: DispatchQueue
    let stateMachine: StateMachine<PlaybackState, PlaybackEvent>
    
    let DEBUG_ON = false

    init(dispatchQueue:DispatchQueue) {
        self.dispatchQueue = dispatchQueue
        self.stateMachine = StateMachine<PlaybackState, PlaybackEvent>(initialState: .stopped)
        self.stateMachine.enableLogging = DEBUG_ON
        super.init()
        self.initializeTransitions()
    }
    
    
    public func stateMachineTransitions() ->  [Transition<PlaybackState, PlaybackEvent>]  {
        return getTransitions()
    }
    
    internal func initializeTransitions() {
        let transitions = self.getTransitions()
        for t in transitions {
            self.stateMachine.add(transition: t)
        }
    }
    
    private func getTransitions() -> [Transition<PlaybackState, PlaybackEvent>] {
        let t1 = Transition<PlaybackState, PlaybackEvent>(with: .startPlayback,
                                                          from: .stopped,
                                                          to: .startingPlayback)
        let t2 = Transition<PlaybackState, PlaybackEvent>(with: .playBackStarted,
                                                          from: .startingPlayback,
                                                          to: .playing)
        let t3 = Transition<PlaybackState, PlaybackEvent>(with: .playPauseTriggered,
                                                          from: .playing,
                                                          to: .paused)
        
        let t4 = Transition<PlaybackState, PlaybackEvent>(with: .playPauseTriggered,
                                                          from: .paused,
                                                          to: .playing)
        
        let t5 = Transition<PlaybackState, PlaybackEvent>(with: .playbackFailed,
                                                          from: .startingPlayback,
                                                          to: .failed)
        
        let t6 = Transition<PlaybackState, PlaybackEvent>(with: .stop,
                                                          from: .failed,
                                                          to: .stopped)
        let t7 = Transition<PlaybackState, PlaybackEvent>(with: .playbackFailed,
                                                          from: .playing,
                                                          to: .failed)
        
        let t8 = Transition<PlaybackState, PlaybackEvent>(with: .playPauseTriggered,
                                                          from: .stopped,
                                                          to: .playFromBeginning)
        let t9 = Transition<PlaybackState, PlaybackEvent>(with: .playbackFinished,
                                                           from: .playing,
                                                           to: .stopped)
        
        let t10 = Transition<PlaybackState, PlaybackEvent>(with: .playBackStarted,
                                                           from: .playFromBeginning,
                                                           to: .playing)
        
        var transitions:[Transition<PlaybackState, PlaybackEvent>] = []
        
        transitions += [t1,t2, t3,t4,t5,t6,t7,t8,t9,t10]
        return transitions
    }
}
