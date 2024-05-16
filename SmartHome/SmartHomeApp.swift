//
//  SmartHomeApp.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

@main
struct SmartHomeApp: App {
    
    var homeModel = HomeModel()
    var mqttManager: MQTTManager
    
    init() {
        self.mqttManager = MQTTManager(homeModel: homeModel)
        homeModel.mqttManager = mqttManager
    }
    
    var body: some Scene {
        WindowGroup {
            ToolBarView()
                .environmentObject(homeModel)
                .environmentObject(mqttManager)
        }
    }
}
