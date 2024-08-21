//
//  SmartHomeApp.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

@main
struct SmartHomeApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    let homeModel: HomeModel
    let settingsViewModel: SettingsViewModel
    init() {
        let mqttManager = MQTTManager()
        self.homeModel = HomeModel(mqttManager: mqttManager)
        self.settingsViewModel = SettingsViewModel(mqttManager: mqttManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ToolBarView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(homeModel)
                .environmentObject(settingsViewModel)
        }
    }
}
