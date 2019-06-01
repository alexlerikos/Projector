//
//  ProjectorView.swift
//  Projector
//
//  Created by Alex Lerikos on 5/30/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

public class ProjectorView: UIView {
    // Public - AVPlayer Attributes
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
    
    override public class var layerClass: AnyClass {
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
    
    
    // Properties
    let nibName = "ProjectorView"
    var contentView: UIView!
    var stateMachine:PlaybackStateMachine!
   
    // IB Properties
    @IBOutlet weak var progressBarSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView(dispatchQueue: DispatchQueue.main)
    }
    
    init(frame: CGRect, stateMachineCallBackQueue:DispatchQueue) {
        super.init(frame: frame)
        self.setUpView(dispatchQueue: stateMachineCallBackQueue)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView(dispatchQueue: DispatchQueue.main)
    }
    
    
    private func setUpView(dispatchQueue:DispatchQueue){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = (nib.instantiate(withOwner: self, options: nil).first as! UIView)
        self.addSubview(contentView)
        
        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        stateMachine = PlaybackStateMachine(dispatchQueue: dispatchQueue)
        self.addTimeObserver()
        
        // delete this later, just for skeleton implementation
        self.playPauseButton.setTitle("Paused", for: .normal)
        self.progressBarSlider.setValue(0.0, animated: false)
        
        self.player = AVPlayer()
    }
    
    @objc private func readBuffer(_ sender: CADisplayLink) {

        var currentTime = CMTime.invalid
        let nextVSync = sender.timestamp + sender.duration
        currentTime = playerItemVideoOutput.itemTime(forHostTime: nextVSync)

        if playerItemVideoOutput.hasNewPixelBuffer(forItemTime: currentTime), let _ = playerItemVideoOutput.copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil) {
        }
    }

    private func addTimeObserver() {
        let timeInterval = CMTimeMakeWithSeconds(0.1, preferredTimescale: 10)
        self.player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: {(elapsedTime: CMTime ) -> Void in
                self.handleTimeObserver(elapsedTime)
            }
        )
    }

    internal func handleTimeObserver(_ elapsedTime:CMTime) {

        guard let currentItem = self.player?.currentItem else {
            return
        }

        let videoDuration = CMTimeGetSeconds(currentItem.asset.duration)
        if videoDuration.isFinite {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            self.progressBarSlider.maximumValue = Float(videoDuration)
            self.progressBarSlider.setValue(Float(elapsedTime), animated: true)
        }

    }

    @IBAction func playPauseButtonPressed(_ sender: Any) {
        print("currennt state \(self.stateMachine.stateMachine.currentState)")
        self.stateMachine.stateMachine.process(event: .playPauseTriggered, callback: { result in
            switch result {
            case .success:
                if self.stateMachine.stateMachine.currentState == .paused {
                    self.pause()
                } else if self.stateMachine.stateMachine.currentState == .playing {
                    self.playFromCurrentTime()
                }
            case .failure:
                print("Error changing state from: \(self.stateMachine.stateMachine.currentState)")
            }
        })
    }
    
    @IBAction func sliderMovingAction(_ sender: Any) {
        
    }
    
    @IBAction func sliderStartedMoving(_ sender: Any) {
       
    }
    
    public func playFromBeginning() {
        self.player?.seek(to: CMTime.zero)
        self.playFromCurrentTime()
    }

    public func playFromCurrentTime() {
        self.playPauseButton.setTitle("Pause", for: .normal)
        displayLink.isPaused = false
        self.player?.play()
    }

    public func pause() {
        guard self.stateMachine.stateMachine.currentState == .paused else {
            return
        }
        self.playPauseButton.setTitle("Play", for: .normal)
        displayLink.isPaused = true
        self.player?.pause()
    }
    
    public func loadURLAsset(_ videoURL:URL){
        let asset = AVAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.add(playerItemVideoOutput)
        self.player?.replaceCurrentItem(with: playerItem)
        self.addTimeObserver()
    }


}
