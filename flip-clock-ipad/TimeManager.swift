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
        
        // 使用 RunLoop 优化 Timer 性能
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.currentTime = Date()
        }
        // 将 Timer 添加到 RunLoop 的 common mode，提高响应性
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
