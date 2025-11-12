//
//  PlaybackButtonStateMachine.swift
//  Projector
//
//  Created by Alex Lerikos on 6/3/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import Foundation

class PlaybackButtonStateMachine: NSObject, StateMachineDelegate {
    let dispatchQueue: DispatchQueue
    let stateMachine: StateMachine<ButtonState, ButtonEvent>
    
    let DEBUG_ON = false
    
    init(dispatchQueue:DispatchQueue) {
        self.dispatchQueue = dispatchQueue
        self.stateMachine = StateMachine<ButtonState, ButtonEvent>(initialState: .paused)
        self.stateMachine.enableLogging = DEBUG_ON
        super.init()
        self.initializeTransitions()
    }
    
    
    public func stateMachineTransitions() ->  [Transition<ButtonState, ButtonEvent>]  {
        return getTransitions()
    }
    
    internal func initializeTransitions() {
        let transitions = self.getTransitions()
        for t in transitions {
            self.stateMachine.add(transition: t)
        }
    }
    
    private func getTransitions() -> [Transition<ButtonState, ButtonEvent>] {
        let t1 = Transition<ButtonState, ButtonEvent>(with: .pauseEvent,
                                                          from: .playing,
                                                          to: .paused)
        let t2 = Transition<ButtonState, ButtonEvent>(with: .playEvent,
                                                      from: .paused,
                                                      to: .playing)
        let t3 = Transition<ButtonState, ButtonEvent>(with: .finishedEvent,
                                                      from: .playing,
                                                      to: .restart)
        let t4 = Transition<ButtonState, ButtonEvent>(with: .finishedEvent,
                                                      from: .paused,
                                                      to: .restart)
        let t5 = Transition<ButtonState, ButtonEvent>(with: .playEvent,
                                                      from: .restart,
                                                      to: .playing)
        
     
        
        var transitions:[Transition<ButtonState, ButtonEvent>] = []
        
        transitions += [t1,t2,t3,t4,t5]
        return transitions
    }
}
