//
//  PlaybackState.swift
//  Projector
//
//  Created by Alex Lerikos on 5/30/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import Foundation


enum PlaybackState {
    case stopped
    case startingPlayback
    case playing
    case playFromBeginning
    case paused
    case failed
}

enum PlaybackEvent {
    case startPlayback
    case playBackStarted
    case playbackFailed
    case playPauseTriggered
    case stop
    case playbackFinished
}
