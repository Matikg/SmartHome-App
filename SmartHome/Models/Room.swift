//
//  Room.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation
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
    var photo: Image {
        switch type {
        case .light:
            return Image("light-bulb")
        case .socket:
            return Image("socket")
        case .thermostat:
            return Image("thermostat")
        case .lock:
            return Image("lock")
        }
    }
    var isOn: Bool
}

enum DeviceType: String, CaseIterable {
    case light, socket, thermostat, lock
    
    var image: String {
        switch self {
        case .light:
            return "light-bulb"
        case .socket:
            return "socket"
        case .thermostat:
            return "thermostat"
        case .lock:
            return "lock"
        }
    }
}

