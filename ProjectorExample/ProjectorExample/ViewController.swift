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
    
    
    @IBOutlet weak var projectorView: ProjectorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoURL1 = URL(fileURLWithPath: Bundle.main.path(forResource: kVideoName, ofType: kVideoType)!)
        let videoURL2 = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
        self.projectorView.loadURLAsset(videoURL2)
    }


}

