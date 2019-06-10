//
//  ProjectorView+PlayerControls.swift
//  Projector
//
//  Created by Alex Lerikos on 6/9/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit
import AVFoundation

extension ProjectorView {
    internal func playFromBeginning() {
        self.player?.seek(to: CMTime.zero)
        self.playbackStateMachine.process(event: .playBackStarted, callback: { result in
            switch result {
            case .success:
                self.playFromCurrentTime()
            case .failure:
                self.printMessage("Error changing state from: \(self.playbackStateMachine.currentState)")
            }
        })
        
    }
    
    internal func playFromCurrentTime() {
        self.playPauseButton.buttonStateEvent(.playEvent)
        self.player?.play()
        self.controlsContainerView.fadeOut()
    }
    
    internal func pause() {
        guard self.playbackStateMachine.currentState == .paused else {
            return
        }
        self.playPauseButton.buttonStateEvent(.pauseEvent)
        self.player?.pause()
    }
    
    internal func playbackFinished(){
        self.playbackStateMachine.process(event: .playbackFinished, callback: { result in
            switch result {
            case .success:
                self.printMessage("success current state: \(self.playbackStateMachine.currentState)")
                self.playPauseButton.buttonStateEvent(.finishedEvent)
                self.controlsContainerView.fadeIn()
            case .failure:
                self.printMessage("Error changing state from: \(self.playbackStateMachine.currentState)")
            }
        })
    }
    
}
