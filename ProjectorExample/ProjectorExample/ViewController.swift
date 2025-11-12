//
//  ViewController.swift
//  ProjectorExample
//
//  Created by Alex Lerikos on 11/12/25.
//

import UIKit
import Projector

class ViewController: UIViewController {
    let kVideoName = "Tahoe-Orbit-Edit"
    let kVideoType = "mp4"
    
    let sliderColor = UIColor(red:44.0/255.0, green:62.0/255.0, blue:88.0/255.0, alpha:1.0)
    
    let projectorView = ProjectorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProjectorView()
        
        // choose either bundled video or web video
        let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: kVideoName, ofType: kVideoType)!)
//        let videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
        self.projectorView.setWaterMarkImage(UIImage(named: "water-mark")!)
        self.projectorView.setDebugLoggingEnabled(true)
        self.projectorView.setProgressSliderTintColor(sliderColor)
        self.projectorView.setControlsButtonTint(sliderColor)
        self.projectorView.loadURLAsset(videoURL)
    }
    
    private func setUpProjectorView() {
        self.projectorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(projectorView)
        NSLayoutConstraint.activate([
            projectorView.topAnchor.constraint(equalTo: view.topAnchor),
            projectorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            projectorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            projectorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

