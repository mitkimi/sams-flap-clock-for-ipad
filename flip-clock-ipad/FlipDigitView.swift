//
//  FlipDigitView.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import SwiftUI

struct FlipDigitView: View, Equatable {
    let digit: Int
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    init(digit: Int, cardWidth: CGFloat = 160, cardHeight: CGFloat = 200) {
        self.digit = digit
        self.cardWidth = cardWidth
        self.cardHeight = cardHeight
    }
    
    static func == (lhs: FlipDigitView, rhs: FlipDigitView) -> Bool {
        lhs.digit == rhs.digit && lhs.cardWidth == rhs.cardWidth && lhs.cardHeight == rhs.cardHeight
    }
    
    var body: some View {
        ZStack {
            // 背景卡片
            RoundedRectangle(cornerRadius: cardWidth * 0.125)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.15))
                .frame(width: cardWidth, height: cardHeight)
            
            // 数字显示层
            VStack(spacing: 0) {
                // 上半部分
                ZStack {
                    RoundedRectangle(cornerRadius: cardWidth * 0.125)
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.23))
                    
                    // 数字被裁剪，只显示上半部分
                    Text("\(digit)")
                        .font(.custom("Impact", size: cardWidth * 0.875))
                        .foregroundColor(.white)
                        .offset(y: cardHeight * 0.25) // 向下偏移，让数字的上半部分显示在上半部分区域
                }
                .frame(height: cardHeight * 0.5)
                .clipped()
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: cardWidth * 0.125,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: cardWidth * 0.125
                    )
                )
                
                // 分隔线
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .frame(height: 3)
                
                // 下半部分
                ZStack {
                    RoundedRectangle(cornerRadius: cardWidth * 0.125)
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.23))
                    
                    // 数字被裁剪，只显示下半部分
                    Text("\(digit)")
                        .font(.custom("Impact", size: cardWidth * 0.875))
                        .foregroundColor(.white)
                        .offset(y: -cardHeight * 0.25) // 向上偏移，让数字的下半部分显示在下半部分区域
                }
                .frame(height: cardHeight * 0.5)
                .clipped()
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: cardWidth * 0.125,
                        bottomTrailingRadius: cardWidth * 0.125,
                        topTrailingRadius: 0
                    )
                )
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .drawingGroup() // 优化GPU渲染性能
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FlipDigitView(digit: 5)
    }
}
