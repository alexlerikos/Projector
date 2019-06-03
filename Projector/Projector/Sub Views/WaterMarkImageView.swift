//
//  WaterMarkImageView.swift
//  Projector
//
//  Created by Alex Lerikos on 6/2/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit

class WaterMarkImageView: UIImageView {

    private var waterMarkImage:UIImage?
    
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
        self.image = waterMarkImage
    }
    
    public func setWaterMarkImage(_ image: UIImage, alpha:CGFloat = 0.5){
        self.waterMarkImage = image
        self.alpha = alpha
        self.setUpView()
    }
}
