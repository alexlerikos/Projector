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
    
    lazy var player: AVPlayer = {
        return self.playerLayer.player!
    }()
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class var  layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    var playbackLikelyToKeepUpContext = 0
    var asset: AVAsset!
    var playerItem: AVPlayerItem?
    
    lazy var playerItemVideoOutput: AVPlayerItemVideoOutput = {
        let attributes = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
        return AVPlayerItemVideoOutput(pixelBufferAttributes: attributes)
    }()
    
    lazy var displayLink: CADisplayLink = {
        let dl = CADisplayLink(target: self, selector: #selector(readBuffer(_:)))
        dl.add(to: .current, forMode: RunLoop.Mode.default)
        dl.isPaused = true
        return dl
    }()
    
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func readBuffer(_ sender: CADisplayLink) {

        var currentTime = CMTime.invalid
        let nextVSync = sender.timestamp + sender.duration
        currentTime = playerItemVideoOutput.itemTime(forHostTime: nextVSync)

        if playerItemVideoOutput.hasNewPixelBuffer(forItemTime: currentTime), let _ = playerItemVideoOutput.copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil) {
        }
    }
//
//    public func addTimeObserver() {
//        let timeInterval = CMTimeMakeWithSeconds(0.1, preferredTimescale: 10)
//        self.avPlayerView.player!.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: {[weak self] (elapsedTime: CMTime ) ->  Void in
//            self!.handleTimeObserver(elapsedTime)
//            }
//        )
//    }
//
//    internal func handleTimeObserver(_ elapsedTime:CMTime) {
//
//        guard let currentItem = self.player.currentItem else {
//            return
//        }
//
//        let videoDuration = CMTimeGetSeconds(currentItem.asset.duration)
//        if videoDuration.isFinite {
//            let elapsedTime = CMTimeGetSeconds(elapsedTime)
//            self.sliderDurationIndicator.maximumValue = Float(videoDuration)
//            self.sliderDurationIndicator.setValue(Float(elapsedTime), animated: true)
//        }
//
//    }
//
//    public func playFromBeginning() {
//        self.player.seek(to: CMTime.zero)
//        self.playFromCurrentTime()
//    }
//
//    public func playFromCurrentTime() {
//        self.playbackState = .Playing
//        self.playPauseButton.setTitle("Pause", for: .normal)
//        displayLink.isPaused = false
//        self.avPlayerView.player!.play()
//    }
//
//    public func pause() {
//        guard self.playbackState == .Playing || self.playbackState == .StartingPlayback else {
//            return
//        }
//        self.playPauseButton.setTitle("Play", for: .normal)
//        displayLink.isPaused = true
//        self.avPlayerView.player!.pause()
//        self.playbackState = .Paused
//
//    }


}
