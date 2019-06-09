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
    
    /// **Void Block TypeAlias**
    typealias GCDTimerBlock =  (() -> Void)
    
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
    
    
    //Overrides
    override public class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    private var playbackLikelyToKeepUpContext = 0
    private var asset: AVAsset!
    private var playerItem: AVPlayerItem?

    // KVO Context
    internal var playerItemContext = 0
    
    // Properties
    private let nibName = "ProjectorView"
    internal let requiredAssetKeys = ["playable", "hasProtectedContent"]
    internal let gcdTimerQueue: DispatchQueue = DispatchQueue(label: "GCDTimerQueue")
    
    internal var contentView: UIView!
    internal var stateMachine:PlaybackStateMachine!
    internal var loggingEnabled:Bool = false
    internal var gcdTimer:DispatchSourceTimer?

    // IB Views
    @IBOutlet weak var progressBarSlider: ProgressSliderView!
    @IBOutlet weak var playPauseButton: PlayPauseRestartButton!
    @IBOutlet weak var controlsContainerView: UIView!
    @IBOutlet weak var waterMarkImageView: WaterMarkImageView!
    @IBOutlet weak var loadingAnimationView: LoadingAnimationView!
    
    //IB Constraints
    @IBOutlet weak var waterMarkImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var waterMarkImageViewHeight: NSLayoutConstraint!
    
    //IB Gesture Recognizers
    @IBOutlet var singleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var doubleTapGestureRecognizer: UITapGestureRecognizer!

    // MARK: Initializers
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

        
        self.singleTapGestureRecognizer.require(toFail: self.doubleTapGestureRecognizer)
        
        stateMachine = PlaybackStateMachine(dispatchQueue: dispatchQueue)
        self.addTimeObserver()
        
        // delete this later, just for skeleton implementation
        self.progressBarSlider.setValue(0.0, animated: false)
        self.controlsContainerView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

        self.player = AVPlayer()
        
        self.loggingEnabled = false

    }
    
    // MARK: Overrided Methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // we need to adjust the frame of the subview to no longer match the size used
        // in the XIB file BUT the actual frame we got assinged from the superview
        self.contentView.frame = self.bounds
    }
    
    // From https://developer.apple.com/documentation/avfoundation/media_assets_playback_and_editing/responding_to_playback_state_changes
    override public func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        // make sure playeritem is not nil
        guard object is AVPlayerItem else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        switch keyPath {
        case #keyPath(AVPlayerItem.isPlaybackBufferFull):
            self.loadingAnimationView.stopAnimation()
            break
        case #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp):
            self.loadingAnimationView.stopAnimation()
            break
        case #keyPath(AVPlayerItem.isPlaybackBufferEmpty):
            self.loadingAnimationView.startAnimation()
            break
        default:
            break
        }
        
    }
    
    // MARK: Time Observer
    internal func addTimeObserver() {
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
            if elapsedTime == videoDuration {
                self.playbackFinished()
            }
        }
        

    }
    
    // MARK: IBA Actions
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        self.printMessage("currennt state \(self.stateMachine.stateMachine.currentState)")
        self.stateMachine.stateMachine.process(event: .playPauseTriggered, callback: { result in
            switch result {
            case .success:
                if self.stateMachine.stateMachine.currentState == .paused {
                    self.pause()
                } else if self.stateMachine.stateMachine.currentState == .playing {
                    self.playFromCurrentTime()
                } else if self.stateMachine.stateMachine.currentState == .playFromBeginning {
                    self.playFromBeginning()
                }
            case .failure:
                self.printMessage("Error changing state from: \(self.stateMachine.stateMachine.currentState)")
            }
        })
    }
    
    @IBAction func sliderMovingAction(_ sender: Any) {
        guard self.player?.currentItem != nil else {
            return
        }
        
        let elapsedTime = Float64(progressBarSlider.value)
        
        self.player?.seek(to: CMTimeMakeWithSeconds(elapsedTime, preferredTimescale: 100), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (completed:Bool) -> Void in
            if self.player?.rate == 0.0 {
                self.playFromCurrentTime()
            }
        }
    }
    
    @IBAction func sliderStartedMoving(_ sender: Any) {
        self.cancelControlsTimer()
        self.pause()
    }
    
    
    @IBAction func sliderReleased(_ sender: Any) {
        let slider = sender as! UISlider
        if slider.value == 1.0 {
            self.playbackFinished()
        } else {

            self.startControlsTimer(1)
        }
        
    }
    
    @IBAction func singleTapGestureAction(_ sender: Any) {
        if self.controlsContainerView.alpha == 0 {
            self.controlsContainerView.fadeInCompletionWithHandler({(complete) -> Void in
                self.startControlsTimer()
            })
        } else if self.controlsContainerView.alpha == 1 {
            self.controlsContainerView.fadeOut()
        }
    }
    
    @IBAction func doubleTapGestureAction(_ sender: Any) {
        if self.controlsContainerView.alpha == 0 {
            self.playerLayer.videoGravity == .resizeAspect ? self.setVideoGravity(.resizeAspectFill) : self.setVideoGravity(.resizeAspect)
        }
    }
    
    /**
     # PrintMessage
     Only prints if *loggingEnabled* property is true

     - Parameter message: Messge to be printed
    */
    internal func printMessage(_ message:String){
        guard loggingEnabled else {
            return
        }
        print(message)
    }


}
