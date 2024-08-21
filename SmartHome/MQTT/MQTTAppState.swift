//
//  MQTTAppState.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation

enum MQTTAppConnectionState: String {
    case connected = "Connected"
    case disconnected = "Disconnected"
    case connecting = "Connecting..."
    
    var isConnected: Bool {
        switch self {
        case .connected:
            return true
        case .disconnected, .connecting:
            return false
        }
    }
}
