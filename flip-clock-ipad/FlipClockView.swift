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
        GeometryReader { geometry in
            let cardSize = calculateCardSize(screenWidth: geometry.size.width, showSeconds: settingsManager.showSeconds)
            let cardWidth = cardSize.width
            let cardHeight = cardSize.height
            let digitSpacing = cardWidth * 0.075
            let groupSpacing = cardWidth * 0.1875
            
            HStack(spacing: settingsManager.showSeconds ? groupSpacing * 0.5 : groupSpacing) {
                // 小时
                HStack(spacing: digitSpacing) {
                    FlipDigitView(digit: hourTens, cardWidth: cardWidth, cardHeight: cardHeight)
                    FlipDigitView(digit: hourOnes, cardWidth: cardWidth, cardHeight: cardHeight)
                }
                
                // 冒号分隔符（带闪烁动画）
                colonView(cardWidth: cardWidth)
                
                // 分钟
                HStack(spacing: digitSpacing) {
                    FlipDigitView(digit: minuteTens, cardWidth: cardWidth, cardHeight: cardHeight)
                    FlipDigitView(digit: minuteOnes, cardWidth: cardWidth, cardHeight: cardHeight)
                }
                
                // 秒（如果启用）
                if settingsManager.showSeconds {
                    // 第二个冒号分隔符
                    colonView(cardWidth: cardWidth)
                    
                    // 秒
                    HStack(spacing: digitSpacing) {
                        FlipDigitView(digit: secondTens, cardWidth: cardWidth, cardHeight: cardHeight)
                        FlipDigitView(digit: secondOnes, cardWidth: cardWidth, cardHeight: cardHeight)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func calculateCardSize(screenWidth: CGFloat, showSeconds: Bool) -> (width: CGFloat, height: CGFloat) {
        let margin: CGFloat = 80 // 左右边距
        let availableWidth = screenWidth - margin * 2
        
        // 计算需要的元素数量
        let digitCount: CGFloat = showSeconds ? 6 : 4
        let colonCount: CGFloat = showSeconds ? 2 : 1
        let digitSpacing: CGFloat = showSeconds ? 0.075 : 0.075 // 相对于卡片宽度的比例
        let groupSpacing: CGFloat = showSeconds ? 0.09375 : 0.1875 // 相对于卡片宽度的比例
        let colonWidth: CGFloat = showSeconds ? 0.125 : 0.25 // 相对于卡片宽度的比例
        
        // 计算卡片宽度：availableWidth = digitCount * cardWidth + (digitCount - 1) * digitSpacing * cardWidth + colonCount * colonWidth * cardWidth + (digitCount/2 - 1) * groupSpacing * cardWidth
        // 简化：availableWidth = cardWidth * (digitCount + (digitCount - 1) * digitSpacing + colonCount * colonWidth + (digitCount/2 - 1) * groupSpacing)
        let totalFactor = digitCount + (digitCount - 1) * digitSpacing + colonCount * colonWidth + (digitCount / 2 - 1) * groupSpacing
        let cardWidth = availableWidth / totalFactor
        
        // 卡片高度保持 1.25 的比例
        let cardHeight = cardWidth * 1.25
        
        return (width: cardWidth, height: cardHeight)
    }
    
    private func colonView(cardWidth: CGFloat) -> some View {
        VStack(spacing: cardWidth * 0.05) {
            Circle()
                .fill(Color.white)
                .frame(width: cardWidth * 0.1, height: cardWidth * 0.1)
                .opacity(blinkingOpacity)
            
            Circle()
                .fill(Color.white)
                .frame(width: cardWidth * 0.1, height: cardWidth * 0.1)
                .opacity(blinkingOpacity)
        }
        .padding(.horizontal, settingsManager.showSeconds ? cardWidth * 0.0625 : cardWidth * 0.125)
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
