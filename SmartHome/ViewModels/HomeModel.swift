//
//  HomeModel.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation
import SwiftUI

class HomeModel: ObservableObject {
    
    @Published var rooms = [Room]()
    var mqttManager: MQTTManager?
    
    init() {
        loadRooms()
    }
    
    func toggleDevice(withId id: String) {
        for index in 0..<rooms.count {
            if let deviceIndex = rooms[index].devices.firstIndex(where: { $0.id == id }) {
                rooms[index].devices[deviceIndex].isOn.toggle()
                publishDeviceState(rooms[index].devices[deviceIndex])
            }
        }
    }
    
    private func publishDeviceState(_ device: Device) {
        let topic = "home/\(device.id)/status"
        let message = device.isOn ? "ON" : "OFF"
        mqttManager!.publish(topic: topic, with: message)
    }
    
    private func loadRooms() {
        rooms = [
            Room(id: "1", name: "Kitchen", photo: "kitchen_photo", devices: [
                Device(id: "101", name: "Light1", type: .light, isOn: false),
                Device(id: "111", name: "Socket1", type: .socket, isOn: false),
                Device(id: "112", name: "Socket2", type: .socket, isOn: false)]),
            
            Room(id: "2", name: "Living Room", photo: "living_photo", devices: [
                Device(id: "201", name: "Light1", type: .light, isOn: false),
                Device(id: "202", name: "Light2", type: .light, isOn: false),
                Device(id: "211", name: "Socket1", type: .socket, isOn: false),
                Device(id: "212", name: "Socket2", type: .socket, isOn: false)]),
            
            Room(id: "3", name: "Bedroom", photo: "bedroom-photo", devices: [
                Device(id: "301", name: "Light1", type: .light, isOn: false),
                Device(id: "302", name: "Light2", type: .light, isOn: false),
                Device(id: "311", name: "Socket", type: .socket, isOn: false)]),
            
            Room(id: "4", name: "Bathroom", photo: "bathroom-photo", devices: [
                Device(id: "401", name: "Light1", type: .light, isOn: false),
                Device(id: "402", name: "Light2", type: .light, isOn: false),
                Device(id: "411", name: "Socket", type: .socket, isOn: false)]),
            
            Room(id: "5", name: "Garage", photo: "garage-photo", devices: [
                Device(id: "501", name: "Light", type: .light, isOn: false),
                Device(id: "511", name: "Socket", type: .socket, isOn: false)]),
            
            Room(id: "6", name: "Garden", photo: "garden-photo", devices: [
                Device(id: "601", name: "Light", type: .light, isOn: false)])
        ]
    }
}

