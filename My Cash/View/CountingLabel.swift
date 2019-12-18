//
//  CountingLabel.swift
//  My Cash
//
//  Created by Roman Rakhlin on 17.12.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    
    let counterVelocity: Float = 3.0
    
    enum CounterAnimationType {
        case linear
        case easeIn
        case easeOut
    }
    
    enum CounterType {
        case int
        case float
    }
    
    var startNumber: Float = 0
    var endNumber: Float = 0
    
    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    
    var timer: Timer?
    
    var counterType: CounterType!
    var counterAnimationType: CounterAnimationType!
    var currentCounterValue: Float {
        if progress > duration { return endNumber }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        
        return startNumber + (update * (endNumber - startNumber))
    }
    
    var endingText: String?
    
    
    func count(fromValue: Float, to toValue: Float, withDuration duration: TimeInterval, animationType animation: CounterAnimationType, counterType: CounterType, withText text: String? = nil) {
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterType = counterType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        self.counterAnimationType = animation
        self.endingText = text
        
        invalidateTimer()
        
        if duration == 0 {
            updateText(value: toValue)
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateValue), userInfo: nil, repeats: true)
    }
    
    @objc func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        
        updateText(value: currentCounterValue)
        
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateText (value: Float) {
        let text = endingText ?? "%"
        switch counterType! {
            
        case .int:
            self.text = "\(Int(value))" + text
            
        case .float:
            self.text = String(format: "%.2f", value) + text
        }
    }
    
    func updateCounter (counterValue: Float) -> Float {
        switch counterAnimationType {
        case .easeIn:
            return powf(counterValue, counterVelocity)
        case .easeOut:
            return 1.0 - powf(1.0 - counterValue, counterVelocity)
        case .linear:
            return counterValue
        default:
            return 0.0
        }
        
        
    }
}
