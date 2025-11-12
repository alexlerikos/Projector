//
//  PlayPauseRestartButton.swift
//  Projector
//
//  Created by Alex Lerikos on 6/2/19.
//  Copyright © 2019 kosdesigns. All rights reserved.
//

import UIKit

class PlayPauseRestartButton: UIButton {
    
    // Public Properties
    public var debugOn: Bool = false
    
    // Private Properties
    private var buttonStateMachine: PlaybackButtonStateMachine!
    private var buttonStateImages: [ButtonState:UIImage]!
    private let bundle = Bundle(identifier: "com.kosdesigns.Projector")
    
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
        self.buttonStateMachine = PlaybackButtonStateMachine(dispatchQueue: .main)
        self.buttonStateImages = [:]
        self.setTitle("", for: .normal)
        self.buttonStateImages[ButtonState.restart] = UIImage(named: "playbackbtn-restart",in: bundle, compatibleWith: nil)
        self.buttonStateImages[ButtonState.paused] = UIImage(named: "playbackbtn-paused",in: bundle, compatibleWith: nil)
        self.buttonStateImages[ButtonState.playing] = UIImage(named: "playbackbtn-playing",in: bundle, compatibleWith: nil)
        self.setImage(self.buttonStateImages[self.buttonStateMachine.stateMachine.currentState], for: .normal)
    }
    
    public func setButtonStateImage(buttonState: ButtonState, image:UIImage){
        self.buttonStateImages[buttonState] = image
    }
    
    public func buttonStateEvent(_ event: ButtonEvent){
        self.buttonStateMachine.stateMachine.process(event: event, callback: { result in
            switch result {
            case .success:
                self.printMessage("success current state: \(self.buttonStateMachine.stateMachine.currentState)")
                self.setImage(self.buttonStateImages[self.buttonStateMachine.stateMachine.currentState], for: .normal)
            case .failure:
                self.printMessage("Error changing state from: \(self.buttonStateMachine.stateMachine.currentState)")
            }
        })
    }
    
    public func printMessage(_ message:String){
        guard debugOn else {
            return
        }
        print(message)
    }
}
