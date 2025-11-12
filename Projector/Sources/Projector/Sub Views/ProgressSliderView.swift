//
//  ProgressSliderView.swift
//  Projector
//
//  Created by Alex Lerikos on 6/2/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit

class ProgressSliderView: UISlider {
    
    private var sliderThumbImageUntouched:UIImage?
    private var sliderTintColor:UIColor?
    private var sliderThumbImageTouched:UIImage?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    override func awakeFromNib() {
        self.setUpView()
    }
    
    private func setUpView() {
        self.setThumbImage(sliderThumbImageUntouched, for: .normal)
        self.setThumbImage(sliderThumbImageTouched, for: .selected)
        self.thumbTintColor = sliderTintColor
        self.tintColor = sliderTintColor
    }
    
    public func setTintColor(_ color:UIColor){
        self.sliderTintColor = color
        self.setUpView()
    }
    
    public func setSliderThumbImageUntouched(_ image:UIImage){
        self.sliderThumbImageUntouched = image
        self.setUpView()
    }
    
    public func setSliderThumbImagTouched(_ image:UIImage){
        self.sliderThumbImageTouched = image
        self.setUpView()
    }
}
