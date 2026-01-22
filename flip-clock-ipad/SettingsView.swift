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
                    
                    HStack {
                        Text("时制")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $settingsManager.is24Hour) {
                            Text("12小时制").tag(false)
                            Text("24小时制").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("©️ 由 田昊天 开发")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
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
