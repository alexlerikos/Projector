//
//  PlayerView.swift
//  Projector
//
//  Created by Alex Lerikos on 5/30/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit
import AVKit

class PlayerView: UIView {

    // Public
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class var  layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    var player = AVPlayer()
    var playbackLikelyToKeepUpContext = 0
    var asset: AVAsset!
    var playerItem: AVPlayerItem?
    
    lazy var playerItemVideoOutput: AVPlayerItemVideoOutput = {
        let attributes = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
        return AVPlayerItemVideoOutput(pixelBufferAttributes: attributes)
    }()
    
    lazy var displayLink: CADisplayLink = {
        let dl = CADisplayLink(target: self, selector: #selector(readBuffer(_:)))
        dl.add(to: .current, forMode: .defaultRunLoopMode)
        dl.isPaused = true
        return dl
    }()
    
    
    

}
