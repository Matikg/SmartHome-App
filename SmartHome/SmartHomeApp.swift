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
    var mqttManager = MQTTManager()
    
    init() {
        homeModel.mqttManager = mqttManager
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeModel)
                .environmentObject(mqttManager)
        }
    }
}
