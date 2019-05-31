//
//  PlaybackState.swift
//  Projector
//
//  Created by Alex Lerikos on 5/30/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit

//enum PlaybackState {
//    case stopped
//    case startingPlayback
//    case playing
//    case paused
//    case failed
//}
//
//enum PlaybackEvent {
//    case startPlayback
//    case playBackStarted
//    case playbackFailed
//    case playPauseTriggered
//    case stop
//}

class PlaybackStateMachine: NSObject {
    let dispatchQueue: DispatchQueue
    let stateMachine: StateMachine<PlaybackState, PlaybackEvent>

    init(dispatchQueue:DispatchQueue) {
        self.dispatchQueue = dispatchQueue
        self.stateMachine = StateMachine<PlaybackState, PlaybackEvent>(initialState: .stopped)
        
        super.init()
    }
    
    
    public func stateMachineTransitions() ->  [Transition<PlaybackState, PlaybackEvent>]  {
        return getTransitions()
    }
    
    private func initializeTransitions() {
        let transitions = self.getTransitions()
        for t in transitions {
            self.stateMachine.add(transition: t)
        }
    }
    
    private func getTransitions() -> [Transition<PlaybackState, PlaybackEvent>] {
        let t1 = Transition<PlaybackState, PlaybackEvent>(with: .startPlayback,
                                                          from: .stopped,
                                                          to: .startingPlayback)
        
        let t2 = Transition<PlaybackState, PlaybackEvent>(with: .startPlayback,
                                                          from: .stopped,
                                                          to: .startingPlayback)
        let t3 = Transition<PlaybackState, PlaybackEvent>(with: .playBackStarted,
                                                          from: .startingPlayback,
                                                          to: .playing)
        let t4 = Transition<PlaybackState, PlaybackEvent>(with: .playPauseTriggered,
                                                          from: .playing,
                                                          to: .paused)
        
        let t5 = Transition<PlaybackState, PlaybackEvent>(with: .playPauseTriggered,
                                                          from: .paused,
                                                          to: .playing)
        
        let t6 = Transition<PlaybackState, PlaybackEvent>(with: .playbackFailed,
                                                          from: .startingPlayback,
                                                          to: .failed)
        
        let t7 = Transition<PlaybackState, PlaybackEvent>(with: .stop,
                                                          from: .failed,
                                                          to: .stopped)
        let t8 = Transition<PlaybackState, PlaybackEvent>(with: .playbackFailed,
                                                          from: .playing,
                                                          to: .failed)
        
        var transitions:[Transition<PlaybackState, PlaybackEvent>] = []
        
        transitions.append(t1)
        transitions.append(t2)
        transitions.append(t3)
        transitions.append(t4)
        transitions.append(t5)
        transitions.append(t6)
        transitions.append(t7)
        transitions.append(t8)
        return transitions
    }
}
