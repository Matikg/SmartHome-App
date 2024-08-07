//
//  HomeModel.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation
import SwiftUI

final class HomeModel: ObservableObject {
    @Published var rooms = [Room]()
    @Published var temperature: String = "20"
    private let mqttManager: MQTTManager
    
    init(mqttManager: MQTTManager) {
        self.mqttManager = mqttManager
        loadRooms()
        // mqttManager.currentValueSubject.sink{}
        
    }
    
    func toggleDevice(withId id: String) {
        for index in 0..<rooms.count {
            if let deviceIndex = rooms[index].devices.firstIndex(where: { $0.id == id }) {
                rooms[index].devices[deviceIndex].isOn.toggle()
                publishDeviceState(rooms[index].devices[deviceIndex], rooms[index])
            }
        }
    }
    
    private func publishDeviceState(_ device: Device, _ room: Room) {
        let topic = "\(room.name)/\(device.id)/status"
        let message = device.isOn ? "TRUE" : "FALSE"
        mqttManager.publish(topic: topic, with: message)
    }
    
    private func loadRooms() {
        rooms = [
            Room(id: "1", name: "Kitchen", photo: "kitchen", devices: [
                Device(id: "101", name: "Light1", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "111", name: "Socket1", type: .socket, photo: "socket", isOn: false),
                Device(id: "112", name: "Socket2", type: .socket, photo: "socket", isOn: false),
                Device(id: "141", name: "Vent", type: .vent, photo: "vent", isOn: false)]),
            
            Room(id: "2", name: "Living Room", photo: "living-room", devices: [
                Device(id: "201", name: "Light1", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "202", name: "Light2", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "211", name: "Socket1", type: .socket, photo: "socket", isOn: false),
                Device(id: "212", name: "Socket2", type: .socket, photo: "socket", isOn: false),
                Device(id: "221", name: "Lock", type: .lock, photo: "lock", isOn: false),
                Device(id: "231", name: "Blinds", type: .blinds, photo: "blinds", isOn: false)]),
            
            Room(id: "3", name: "Bedroom", photo: "bedroom", devices: [
                Device(id: "301", name: "Light1", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "302", name: "Light2", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "311", name: "Socket", type: .socket, photo: "socket", isOn: false),
                Device(id: "331", name: "Blinds", type: .blinds, photo: "blinds", isOn: false)]),
            
            Room(id: "4", name: "Bathroom", photo: "bathroom", devices: [
                Device(id: "401", name: "Light1", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "402", name: "Light2", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "411", name: "Socket", type: .socket, photo: "socket", isOn: false),
                Device(id: "441", name: "Vent", type: .vent, photo: "vent", isOn: false)]),
            
            Room(id: "5", name: "Garage", photo: "garage", devices: [
                Device(id: "501", name: "Light", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "511", name: "Socket", type: .socket, photo: "socket", isOn: false),
                Device(id: "521", name: "Lock", type: .lock, photo: "lock", isOn: false)]),
            
            Room(id: "6", name: "Garden", photo: "garden", devices: [
                Device(id: "601", name: "Light", type: .light, photo: "light-bulb", isOn: false),
                Device(id: "621", name: "Lock", type: .lock, photo: "lock", isOn: false)])
        ]
    }
}

