//
//  LoadingAnimationView.swift
//  Projector
//
//  Created by Alex Lerikos on 6/1/19.
//  Copyright © 2019 UhuApps. All rights reserved.
//

import UIKit

class LoadingAnimationView: UIView {

    private var activityIndicator: UIActivityIndicatorView
    
    required init(coder aDecoder: NSCoder) {
        self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        super.init(coder: aDecoder)!
        self.setUpView()
    }
    
    override init(frame: CGRect) {
        self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        super.init(frame: frame)
        self.setUpView()
    }
    
    override func awakeFromNib() {
        self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.setUpView()
    }
    
    private func setUpView() {
        self.activityIndicator.hidesWhenStopped = true
        self.addSubview(self.activityIndicator)
    }
    
    public func startAnimation() {
        self.activityIndicator.startAnimating()
    }
    
    public func stopAnimation() {
        self.activityIndicator.stopAnimating()
    }
    
    public func isAnimating() -> Bool {
       return self.activityIndicator.isAnimating
    }

}
