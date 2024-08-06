//
//  MQTTAppState.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation

enum MQTTAppConnectionState {
    case connected
    case disconnected
    case connecting
    
    var description: String {
        switch self {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        }
    }
    
    var isConnected: Bool {
        switch self {
        case .connected:
            return true
        case .disconnected, .connecting:
            return false
        }
    }
}

final class MQTTAppState: ObservableObject {
    @Published var appConnectionState: MQTTAppConnectionState = .disconnected
    
    func setAppConnectionState(state: MQTTAppConnectionState) {
        self.appConnectionState = state
    }
}




