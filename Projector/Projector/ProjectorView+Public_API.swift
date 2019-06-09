//
//  ProjectorView+Public_API.swift
//  Projector
//
//  Created by Alex Lerikos on 6/9/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit
import AVFoundation

extension ProjectorView {
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
    
    public func setControlsButtonImageForPlaying(_ image:UIImage){
        self.playPauseButton.setButtonStateImage(buttonState: .playing, image: image)
    }
    
    public func setControlsButtonImageForPaused(_ image:UIImage){
        self.playPauseButton.setButtonStateImage(buttonState: .paused, image: image)
    }
    
    public func setControlsButtonImageForRestart(_ image:UIImage){
        self.playPauseButton.setButtonStateImage(buttonState: .restart, image: image)
    }
    
    public func setControlsButtonTint(_ color:UIColor){
        self.playPauseButton.tintColor = color
    }
    
}
