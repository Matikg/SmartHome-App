//
//  Room.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct Room: Identifiable {
    var id: String
    var name: String
    var photo: String
    var devices: [Device]
}

struct Device: Identifiable {
    var id: String
    var name: String
    var type: DeviceType
    var isOn: Bool
    
    var photo: String {
        switch type {
        case .lock:
            return isOn ? "lock" : "unlock"
        case .light:
            return isOn ? "bulb-on" : "bulb-off"
        case .socket:
            return isOn ? "socket-on" : "socket"
        default:
            return type.image
        }
    }
}

enum DeviceType: String, CaseIterable {
    case light, socket, lock, blinds, vent
    
    var image: String {
        switch self {
        case .light:
            return "bulb-off"
        case .socket:
            return "socket"
        case .lock:
            return "lock"
        case .blinds:
            return "blinds"
        case .vent:
            return "vent"
        }
    }
}

