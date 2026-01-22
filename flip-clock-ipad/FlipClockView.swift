//
//  FlipClockView.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import SwiftUI

struct FlipClockView: View {
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        HStack(spacing: settingsManager.showSeconds ? 15 : 30) {
            // 小时
            HStack(spacing: 12) {
                FlipDigitView(digit: hourTens)
                FlipDigitView(digit: hourOnes)
            }
            
            // 冒号分隔符（带闪烁动画）
            colonView
            
            // 分钟
            HStack(spacing: 12) {
                FlipDigitView(digit: minuteTens)
                FlipDigitView(digit: minuteOnes)
            }
            
            // 秒（如果启用）
            if settingsManager.showSeconds {
                // 第二个冒号分隔符
                colonView
                
                // 秒
                HStack(spacing: 12) {
                    FlipDigitView(digit: secondTens)
                    FlipDigitView(digit: secondOnes)
                }
            }
        }
    }
    
    private var colonView: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .opacity(blinkingOpacity)
            
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .opacity(blinkingOpacity)
        }
        .padding(.horizontal, settingsManager.showSeconds ? 10 : 20)
        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: blinkingOpacity)
    }
    
    private var blinkingOpacity: Double {
        let seconds = Calendar.current.component(.second, from: timeManager.currentTime)
        return seconds % 2 == 0 ? 1.0 : 0.3
    }
    
    private var hourTens: Int {
        let hour = currentHour
        return hour / 10
    }
    
    private var hourOnes: Int {
        let hour = currentHour
        return hour % 10
    }
    
    private var currentHour: Int {
        let hour24 = Calendar.current.component(.hour, from: timeManager.currentTime)
        if settingsManager.is24Hour {
            return hour24
        } else {
            let hour12 = hour24 % 12
            return hour12 == 0 ? 12 : hour12
        }
    }
    
    private var minuteTens: Int {
        let minute = Calendar.current.component(.minute, from: timeManager.currentTime)
        return minute / 10
    }
    
    private var minuteOnes: Int {
        let minute = Calendar.current.component(.minute, from: timeManager.currentTime)
        return minute % 10
    }
    
    private var secondTens: Int {
        let second = Calendar.current.component(.second, from: timeManager.currentTime)
        return second / 10
    }
    
    private var secondOnes: Int {
        let second = Calendar.current.component(.second, from: timeManager.currentTime)
        return second % 10
    }
}
