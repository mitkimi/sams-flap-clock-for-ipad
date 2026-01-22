//
//  flip_clock_ipadApp.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import SwiftUI

@main
struct flip_clock_ipadApp: App {
    @StateObject private var timeManager = TimeManager()
    @StateObject private var settingsManager = SettingsManager()
    
    init() {
        // 保持屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timeManager)
                .environmentObject(settingsManager)
                .preferredColorScheme(.dark)
                .onAppear {
                    // 确保屏幕常亮设置生效
                    UIApplication.shared.isIdleTimerDisabled = true
                }
        }
    }
}
