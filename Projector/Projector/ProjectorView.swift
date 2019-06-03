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
    
    private var playbackLikelyToKeepUpContext = 0
    private var asset: AVAsset!
    private var playerItem: AVPlayerItem?

    
    // KVO Context
    private var playerItemContext = 0
    
    // Properties
    private let nibName = "ProjectorView"
    private let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    
    private var contentView: UIView!
    private var stateMachine:PlaybackStateMachine!
    private var loggingEnabled:Bool = false
   
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
    
    // MARK: Public API
    public func loadURLAsset(_ videoURL:URL){
        let asset = AVAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: requiredAssetKeys)
        
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferFull), options: [.new], context: &playerItemContext)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp), options: [.new], context: &playerItemContext)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty), options: [.new], context: &playerItemContext)
        
        self.player?.replaceCurrentItem(with: playerItem)
        self.addTimeObserver()
    }
    
    public func setWaterMarkImage(_ image:UIImage, alpha:CGFloat? = nil){
        
        self.waterMarkImageViewWidth.constant = image.size.width
        self.waterMarkImageViewHeight.constant = image.size.height
        self.layoutSubviews()
        
        alpha != nil ? self.waterMarkImageView.setWaterMarkImage(image, alpha: alpha!) : self.waterMarkImageView.setWaterMarkImage(image)
    }
    
    public func setVideoGravity(_ videoGravity: AVLayerVideoGravity){
        self.playerLayer.videoGravity = videoGravity
    }
    
    public func setLoggingEnabled(_ enabled:Bool){
        self.loggingEnabled = enabled
        self.playPauseButton.debugOn = enabled
    }
    
    public func setProgressSliderThumbSelectedImage(_ image: UIImage){
        self.progressBarSlider.setSliderThumbImagTouched(image)
    }
    
    public func setProgressSliderThumbUnselectedImage(_ image: UIImage){
        self.progressBarSlider.setSliderThumbImageUntouched(image)
    }
    
    public func setProgressSliderTintColor(_ color: UIColor){
        self.progressBarSlider.setTintColor(color)
    }
    
    
    // MARK: Time Observer
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
        self.pause()
    }
    
    
    @IBAction func sliderReleased(_ sender: Any) {
        let slider = sender as! UISlider
        if slider.value == 1.0 {
            self.playbackFinished()
        } else {
            self.controlsContainerView.fadeOutWithDelay(1.0)
        }
        
    }
    
    @IBAction func singleTapGestureAction(_ sender: Any) {
        if self.controlsContainerView.alpha == 0 {
            self.controlsContainerView.fadeInCompletionWithHandler({(complete) -> Void in
                // replace with nstimer and use a hashmap for the timers - Alex 6-1-2019    q1d32
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {() -> Void in
                    guard !self.progressBarSlider.isTouchInside else {
                        return
                    }
                    self.controlsContainerView.fadeOut()
                })
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
    
    
    // MARK: Player Control
    public func playFromBeginning() {
        self.player?.seek(to: CMTime.zero)
        self.stateMachine.stateMachine.process(event: .playBackStarted, callback: { result in
            switch result {
            case .success:
                self.playFromCurrentTime()
            case .failure:
                self.printMessage("Error changing state from: \(self.stateMachine.stateMachine.currentState)")
            }
        })
        
    }

    public func playFromCurrentTime() {
        self.playPauseButton.buttonStateEvent(.playEvent)
        self.player?.play()
        self.controlsContainerView.fadeOut()
    }


    
    private func pause() {
        guard self.stateMachine.stateMachine.currentState == .paused else {
            return
        }
        self.playPauseButton.buttonStateEvent(.pauseEvent)
        self.player?.pause()
    }
    
    private func playbackFinished(){
        self.stateMachine.stateMachine.process(event: .playbackFinished, callback: { result in
            switch result {
            case .success:
                self.printMessage("success current state: \(self.stateMachine.stateMachine.currentState)")
                self.playPauseButton.buttonStateEvent(.finishedEvent)
                self.controlsContainerView.fadeIn()
            case .failure:
                self.printMessage("Error changing state from: \(self.stateMachine.stateMachine.currentState)")
            }
        })
    }
    
    private func printMessage(_ message:String){
        guard loggingEnabled else {
            return
        }
        print(message)
    }


}
