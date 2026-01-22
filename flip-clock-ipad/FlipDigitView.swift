//
//  FlipDigitView.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import SwiftUI

struct FlipDigitView: View {
    let digit: Int
    
    var body: some View {
        ZStack {
            // 背景卡片
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.15))
                .frame(width: 160, height: 200)
            
            // 数字显示层
            VStack(spacing: 0) {
                // 上半部分
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.23))
                    
                    // 数字被裁剪，只显示上半部分
                    Text("\(digit)")
                        .font(.custom("Impact", size: 140))
                        .foregroundColor(.white)
                        .offset(y: 50) // 向下偏移，让数字的上半部分显示在上半部分区域
                }
                .frame(height: 100)
                .clipped()
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20
                    )
                )
                
                // 分隔线
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .frame(height: 3)
                
                // 下半部分
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.23))
                    
                    // 数字被裁剪，只显示下半部分
                    Text("\(digit)")
                        .font(.custom("Impact", size: 140))
                        .foregroundColor(.white)
                        .offset(y: -50) // 向上偏移，让数字的下半部分显示在下半部分区域
                }
                .frame(height: 100)
                .clipped()
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 20,
                        topTrailingRadius: 0
                    )
                )
            }
        }
        .frame(width: 160, height: 200)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FlipDigitView(digit: 5)
    }
}
