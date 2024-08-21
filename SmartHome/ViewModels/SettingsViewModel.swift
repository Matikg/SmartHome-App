//
//  SettingsViewModel.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 04/08/2024.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    private let mqttManager: MQTTManager
    
    @Published var host: String = "192.168.0.12"
    @Published var identifier: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var serverState: MQTTAppConnectionState = .disconnected
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mqttManager: MQTTManager) {
        self.mqttManager = mqttManager
        mqttManager.serverConnectionState
        // Można użyć assign
            .sink { [weak self] state in
                self?.serverState = state
            }
            .store(in: &cancellables)
    }
    
    func connect() {
        mqttManager.initializeMQTT(host: host, identifier: identifier, username: username, password: password)
        mqttManager.connect()
    }
    
    func disconnect() {
        mqttManager.disconnect()
    }
}
