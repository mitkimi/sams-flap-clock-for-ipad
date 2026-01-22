//
//  SettingsManager.swift
//  flip-clock-ipad
//
//  Created by KIMI TIN on 22/01/2026.
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    @Published var showSeconds: Bool = false {
        didSet {
            UserDefaults.standard.set(showSeconds, forKey: "showSeconds")
        }
    }
    
    @Published var is24Hour: Bool = true {
        didSet {
            UserDefaults.standard.set(is24Hour, forKey: "is24Hour")
        }
    }
    
    init() {
        // 从 UserDefaults 加载设置
        showSeconds = UserDefaults.standard.bool(forKey: "showSeconds")
        // 如果没有设置过，默认使用 24 小时制
        if UserDefaults.standard.object(forKey: "is24Hour") == nil {
            is24Hour = true
        } else {
            is24Hour = UserDefaults.standard.bool(forKey: "is24Hour")
        }
    }
}
