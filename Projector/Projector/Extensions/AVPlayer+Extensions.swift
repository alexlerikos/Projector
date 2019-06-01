//
//  AVPlayer+Extensions.swift
//  Projector
//
//  Created by Alex Lerikos on 5/31/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import Foundation
import AVFoundation


extension AVPlayer {
    var isPlaying:Bool {
        
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
}
