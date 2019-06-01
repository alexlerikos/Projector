//
//  UIView+Extensions.swift
//  Projector
//
//  Created by Alex Lerikos on 5/31/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import Foundation

// Based off Fouad's answer at https://stackoverflow.com/questions/35385856/how-to-make-a-label-fade-in-or-out-in-swift
extension UIView {
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func fadeOutWithDelay(_ delay: TimeInterval) {
        self.fadeOut(duration: 0.5, delay: delay, completion: {(Bool) -> Void in })
    }
    
    func fadeInCompletionWithHandler(_ completionHandler: @escaping (Bool) -> Void) {
        self.fadeIn(duration: 0.5, delay: 0.0, completion: completionHandler)
    }
}
