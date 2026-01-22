//
//  TimeManager.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import Foundation
import Combine

class TimeManager: ObservableObject {
    @Published var currentTime: Date = Date()
    
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    func startTimer() {
        // 立即更新一次
        currentTime = Date()
        
        // 每秒更新一次
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.currentTime = Date()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
