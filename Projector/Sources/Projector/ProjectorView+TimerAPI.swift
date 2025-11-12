//
//  ProjectorView+TimerAPI.swift
//  Projector
//
//  Created by Alex Lerikos on 6/9/19.
//  Copyright © 2019 UhuApps. All rights reserved.
//

import Foundation

extension ProjectorView {
    /**
     # startControlsTimer
     3 second timer that resets at each touch
     */
    internal func startControlsTimer(_ delay: Int = 3){
        self.scheduledTimerWithTimeInterval(interval: delay, executionBlock:{() -> Void in
            DispatchQueue.main.async {
                self.controlsContainerView.fadeOut()
            }
        }, repeats: false)
    }
    
    /**
     # cancelControlsTimer
    cancels gcd timer
    */
    internal func cancelControlsTimer(){
        self.gcdTimer?.cancel()
        self.gcdTimer = nil
    }
    
    
    /// *based on http://www.acttos.org/2016/08/NSTimer-and-GCD-Timer-in-iOS/*
    internal func scheduledTimerWithTimeInterval(interval: Int, executionBlock:@escaping GCDTimerBlock, repeats: Bool) -> Void {
        if (self.gcdTimer != nil) {
            self.gcdTimer!.cancel();
        }
        self.gcdTimer = DispatchSource.makeTimerSource(flags: [], queue: self.gcdTimerQueue)
        
        self.gcdTimer?.schedule(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(interval))
        
        self.gcdTimer?.setEventHandler(handler: DispatchWorkItem(block: executionBlock))
        
        self.printMessage("Controls visibility GCD timer will resume");
        gcdTimer!.resume();
    }
}
