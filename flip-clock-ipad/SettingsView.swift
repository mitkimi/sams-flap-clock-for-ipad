//
//  SettingsView.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("时间显示")) {
                    Toggle("显示秒", isOn: $settingsManager.showSeconds)
                    
                    Picker("时间制式", selection: $settingsManager.is24Hour) {
                        Text("12小时制").tag(false)
                        Text("24小时制").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
