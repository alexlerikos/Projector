//
//  ViewController.swift
//  ProjectorExample
//
//  Created by Alex Lerikos on 5/30/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit
import Projector

class ViewController: UIViewController {
    
    let kVideoName = "EJ_pass"
    let kVideoType = "mp4"
    
    let sliderColor = UIColor(red:44.0/255.0, green:62.0/255.0, blue:88.0/255.0, alpha:1.0)
    
    
    @IBOutlet weak var projectorView: ProjectorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // choose either bundled video or web video
        let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: kVideoName, ofType: kVideoType)!)
//        let videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
        self.projectorView.setWaterMarkImage(UIImage(named: "water-mark")!)
        self.projectorView.setLoggingEnabled(true)
        self.projectorView.setProgressSliderTintColor(sliderColor)
        self.projectorView.setControlsButtonTint(sliderColor)
        self.projectorView.loadURLAsset(videoURL)
    }


}

