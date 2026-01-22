//
//  ContentView.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showSettings = false
    @State private var showSettingsButton = false
    @State private var hideTask: Task<Void, Never>? = nil
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .contentShape(Rectangle()) // 确保整个背景可点击
                .onTapGesture {
                    showSettingsButton = true
                    startHideTimer()
                }
            
            FlipClockView()
                .environmentObject(timeManager)
                .environmentObject(settingsManager)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false) // 让点击事件穿透到背景，或者也可以在 FlipClockView 上加点击
            
            // 设置按钮
            if showSettingsButton {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(settingsManager)
        }
    }
    
    private func startHideTimer() {
        // 取消之前的定时器
        hideTask?.cancel()
        
        // 创建新的 10 秒定时器
        hideTask = Task {
            try? await Task.sleep(nanoseconds: 10 * 1_000_000_000)
            if !Task.isCancelled {
                showSettingsButton = false
            }
        }
    }
}

#Preview("竖屏") {
    ContentView()
        .environmentObject(TimeManager())
        .environmentObject(SettingsManager())
}

#Preview("横屏", traits: .landscapeLeft) {
    ContentView()
        .environmentObject(TimeManager())
        .environmentObject(SettingsManager())
}
