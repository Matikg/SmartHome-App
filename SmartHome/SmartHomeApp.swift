//
//  SmartHomeApp.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

@main
struct SmartHomeApp: App {
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
                .environmentObject(homeModel)
                .environmentObject(settingsViewModel)
        }
    }
}
