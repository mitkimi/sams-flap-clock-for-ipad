//
//  FlipDigitView.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import SwiftUI

struct FlipDigitView: View {
    let digit: Int
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    @State private var previousDigit: Int = 0
    @State private var flipAngle: Double = 0
    @State private var showNext: Bool = false
    
    init(digit: Int, cardWidth: CGFloat = 160, cardHeight: CGFloat = 200) {
        self.digit = digit
        self.cardWidth = cardWidth
        self.cardHeight = cardHeight
    }
    
    var body: some View {
        ZStack {
            // 背景卡片
            RoundedRectangle(cornerRadius: cardWidth * 0.125)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.15))
                .frame(width: cardWidth, height: cardHeight)
            
            // 静态显示层（当前数字）
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
            .opacity(flipAngle == 0 ? 1 : 0)
            
            // 翻页动画层
            if flipAngle > 0 {
                VStack(spacing: 0) {
                    // 上半部分翻页 - 显示旧数字，向下翻
                    ZStack {
                        RoundedRectangle(cornerRadius: cardWidth * 0.125)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.25))
                        
                        // 显示旧数字或新数字的上半部分
                        Text(showNext ? "\(digit)" : "\(previousDigit)")
                            .font(.custom("Impact", size: cardWidth * 0.875))
                            .foregroundColor(.white)
                            .offset(y: cardHeight * 0.25) // 向下偏移，显示数字的上半部分
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
                    .rotation3DEffect(
                        .degrees(-flipAngle),
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .bottom
                    )
                    .opacity(flipAngle <= 90 ? 1 : 0)
                    
                    // 分隔线
                    Rectangle()
                        .fill(Color.black.opacity(0.4))
                        .frame(height: 3)
                    
                    // 下半部分翻页 - 显示新数字，向上翻
                    ZStack {
                        RoundedRectangle(cornerRadius: cardWidth * 0.125)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.25))
                        
                        // 显示新数字的下半部分
                        Text("\(digit)")
                            .font(.custom("Impact", size: cardWidth * 0.875))
                            .foregroundColor(.white)
                            .offset(y: -cardHeight * 0.25) // 向上偏移，显示数字的下半部分
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
                    .rotation3DEffect(
                        .degrees(showNext ? (90 - flipAngle) : (180 - flipAngle)),
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .top
                    )
                    .opacity(flipAngle >= 90 ? 1 : 0)
                }
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .onChange(of: digit) { oldValue, newValue in
            if oldValue != newValue {
                previousDigit = oldValue
                showNext = false
                flipAngle = 0
                
                // 开始翻页动画：上半部分向下翻
                withAnimation(.easeIn(duration: 0.15)) {
                    flipAngle = 90
                }
                
                // 翻到一半时切换数字，下半部分向上翻
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    showNext = true
                    withAnimation(.easeOut(duration: 0.15)) {
                        flipAngle = 0
                    }
                    
                    // 动画结束后重置
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        flipAngle = 0
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FlipDigitView(digit: 5)
    }
}
