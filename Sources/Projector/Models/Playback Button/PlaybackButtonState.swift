//
//  PlaybackButtonState.swift
//  Projector
//
//  Created by Alex Lerikos on 6/2/19.
//  Copyright © 2019 UhuApps. All rights reserved.
//

import Foundation

enum ButtonState {
    case paused
    case playing
    case restart
}

enum ButtonEvent {
    case pauseEvent
    case playEvent
    case finishedEvent
}
