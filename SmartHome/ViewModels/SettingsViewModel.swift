//
//  SettingsViewModel.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 04/08/2024.
//

import Foundation

class SettingsViewModel: ObservableObject {
    private let mqttManager: MQTTManager
    
    @Published var host: String = "192.168.0.12"
    @Published var identifier: String = "iOS Device"
    @Published var username: String = "BarMat"
    @Published var password: String = "test"
    
    init(mqttManager: MQTTManager) {
        self.mqttManager = mqttManager
    }
    
    func initialize() {
        mqttManager.initializeMQTT(host: host, identifier: identifier, username: username, password: password)
    }
    
    func connect() {
        mqttManager.connect()
    }
    
    func disconnect() {
        mqttManager.disconnect()
    }
}
