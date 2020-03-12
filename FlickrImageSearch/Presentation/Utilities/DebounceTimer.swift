//
//  DebounceTimer.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/12/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

class DebounceTimer {
    
    /// Callback to be debounced
    /// Perform the work you would like to be debounced in this callback.
    var callback: (() -> Void)?
    
    private let interval: TimeInterval // Time interval of the debounce window
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    private var timer: Timer?
    
    /// Indicate that the callback should be called. Begins the debounce window.
    func call() {
        // Invalidate existing timer if there is one
        invalidateTimer()
        // Begin a new timer from now
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
    }
    
    func invalidateTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func handleTimer(_ timer: Timer) {
        callback?()
        callback = nil
    }
    
}
