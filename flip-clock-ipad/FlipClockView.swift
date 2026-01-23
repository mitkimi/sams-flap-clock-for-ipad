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
    
    // 缓存卡片尺寸，避免每次重新计算
    @State private var cardWidth: CGFloat = 160
    @State private var cardHeight: CGFloat = 200
    @State private var digitSpacing: CGFloat = 12
    @State private var groupSpacing: CGFloat = 30
    
    var body: some View {
        HStack(spacing: settingsManager.showSeconds ? groupSpacing * 0.5 : groupSpacing) {
            // 小时
            HStack(spacing: digitSpacing) {
                FlipDigitView(digit: hourTens, cardWidth: cardWidth, cardHeight: cardHeight)
                    .id("hourTens-\(hourTens)")
                FlipDigitView(digit: hourOnes, cardWidth: cardWidth, cardHeight: cardHeight)
                    .id("hourOnes-\(hourOnes)")
            }
            
            // 冒号分隔符（带闪烁动画）
            ColonView(cardWidth: cardWidth, showSeconds: settingsManager.showSeconds)
                .environmentObject(timeManager)
            
            // 分钟
            HStack(spacing: digitSpacing) {
                FlipDigitView(digit: minuteTens, cardWidth: cardWidth, cardHeight: cardHeight)
                    .id("minuteTens-\(minuteTens)")
                FlipDigitView(digit: minuteOnes, cardWidth: cardWidth, cardHeight: cardHeight)
                    .id("minuteOnes-\(minuteOnes)")
            }
            
            // 秒（如果启用）
            if settingsManager.showSeconds {
                // 第二个冒号分隔符
                ColonView(cardWidth: cardWidth, showSeconds: settingsManager.showSeconds)
                    .environmentObject(timeManager)
                
                // 秒
                HStack(spacing: digitSpacing) {
                    FlipDigitView(digit: secondTens, cardWidth: cardWidth, cardHeight: cardHeight)
                        .id("secondTens-\(secondTens)")
                    FlipDigitView(digit: secondOnes, cardWidth: cardWidth, cardHeight: cardHeight)
                        .id("secondOnes-\(secondOnes)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        updateCardSize(width: geometry.size.width)
                    }
                    .onChange(of: geometry.size.width) { _, newWidth in
                        updateCardSize(width: newWidth)
                    }
                    .onChange(of: settingsManager.showSeconds) { _, _ in
                        updateCardSize(width: geometry.size.width)
                    }
            }
        )
    }
    
    private func updateCardSize(width: CGFloat) {
        let margin: CGFloat = 80
        let availableWidth = width - margin * 2
        
        let digitCount: CGFloat = settingsManager.showSeconds ? 6 : 4
        let colonCount: CGFloat = settingsManager.showSeconds ? 2 : 1
        let digitSpacingRatio: CGFloat = 0.075
        let groupSpacingRatio: CGFloat = settingsManager.showSeconds ? 0.09375 : 0.1875
        let colonWidthRatio: CGFloat = settingsManager.showSeconds ? 0.125 : 0.25
        
        let totalFactor = digitCount + (digitCount - 1) * digitSpacingRatio + colonCount * colonWidthRatio + (digitCount / 2 - 1) * groupSpacingRatio
        let newCardWidth = availableWidth / totalFactor
        let newCardHeight = newCardWidth * 1.25
        
        cardWidth = newCardWidth
        cardHeight = newCardHeight
        digitSpacing = newCardWidth * digitSpacingRatio
        groupSpacing = newCardWidth * groupSpacingRatio
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

// 独立的冒号视图，优化动画性能
struct ColonView: View {
    let cardWidth: CGFloat
    let showSeconds: Bool
    @EnvironmentObject var timeManager: TimeManager
    @State private var opacity: Double = 1.0
    
    var body: some View {
        VStack(spacing: cardWidth * 0.05) {
            Circle()
                .fill(Color.white)
                .frame(width: cardWidth * 0.1, height: cardWidth * 0.1)
                .opacity(opacity)
            
            Circle()
                .fill(Color.white)
                .frame(width: cardWidth * 0.1, height: cardWidth * 0.1)
                .opacity(opacity)
        }
        .padding(.horizontal, showSeconds ? cardWidth * 0.0625 : cardWidth * 0.125)
        .onChange(of: timeManager.currentTime) { _, _ in
            let seconds = Calendar.current.component(.second, from: timeManager.currentTime)
            let newOpacity = seconds % 2 == 0 ? 1.0 : 0.3
            if abs(newOpacity - opacity) > 0.01 {
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacity = newOpacity
                }
            }
        }
        .onAppear {
            let seconds = Calendar.current.component(.second, from: timeManager.currentTime)
            opacity = seconds % 2 == 0 ? 1.0 : 0.3
        }
    }
}
