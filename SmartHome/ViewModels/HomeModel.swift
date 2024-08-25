//
//  HomeModel.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation
import SwiftUI
import Combine

final class HomeModel: ObservableObject {
    @Published var rooms = [Room]()
    @Published var scenes = [HomeScene]()
    @Published var temperature = "20.0"
    @Published var power = "25.3"
    @Published var selectedScene: HomeScene? = nil
    @Published var setTemperature = 15.0
    @Published var tempLog = ""
    
    let minTemperature = 0.0
    let maxTemperature = 30.0
    private let mqttManager: MQTTManager
    private var cancellables = Set<AnyCancellable>()
    
    init(mqttManager: MQTTManager) {
        self.mqttManager = mqttManager
        loadRooms()
        loadScenes()
        mqttManager.topicSubject
            .sink { [weak self] topic in
                guard let self else { return }
                switch topic {
                case .temperature(let value):
                    self.temperature = value
                case .power(let value):
                    self.power = value
                case .tempLog(let value):
                    self.tempLog = value
                case .tempSet(let value):
                    self.setTemperature = Double(value) ?? 0.0
                case .unknown:
                    break
                }
            }
            .store(in: &cancellables)
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
        let topic = "\(room.name.lowercased())/\(device.id)/status"
        let message = device.isOn ? "TRUE" : "FALSE"
        mqttManager.publish(topic: topic, with: message)
    }
    
    func numberOfDevicesOn(ofType type: DeviceType) -> Int {
        let devicesOn = rooms.flatMap { $0.devices }
            .filter { $0.type == type && $0.isOn }
        return devicesOn.count
    }
    
    private func loadRooms() {
        rooms = [
            Room(id: "1", name: "Kitchen", photo: "kitchen", devices: [
                Device(id: "101", name: "Ceiling Light", type: .light, isOn: false),
                Device(id: "111", name: "Coffee Maker Plug", type: .socket, isOn: false),
                Device(id: "112", name: "Toaster Plug", type: .socket, isOn: false),
                Device(id: "141", name: "Range Hood Fan", type: .vent, isOn: false)]),
            
            Room(id: "2", name: "Living Room", photo: "living-room", devices: [
                Device(id: "201", name: "Ceiling Light", type: .light, isOn: false),
                Device(id: "202", name: "Floor Lamp", type: .light, isOn: false),
                Device(id: "211", name: "TV Plug", type: .socket, isOn: false),
                Device(id: "212", name: "Sound System Plug", type: .socket, isOn: false),
                Device(id: "221", name: "Front Door Lock", type: .lock, isOn: false),
                Device(id: "231", name: "Window Blinds", type: .blinds, isOn: false)]),
            
            Room(id: "3", name: "Bedroom", photo: "bedroom", devices: [
                Device(id: "301", name: "Bedside Lamp 1", type: .light, isOn: false),
                Device(id: "302", name: "Bedside Lamp 2", type: .light, isOn: false),
                Device(id: "311", name: "Phone Charger Plug", type: .socket, isOn: false),
                Device(id: "331", name: "Curtains", type: .blinds, isOn: false)]),
            
            Room(id: "4", name: "Bathroom", photo: "bathroom", devices: [
                Device(id: "401", name: "Ceiling Light", type: .light, isOn: false),
                Device(id: "402", name: "Mirror Light", type: .light, isOn: false),
                Device(id: "411", name: "Hair Dryer Plug", type: .socket, isOn: false),
                Device(id: "441", name: "Exhaust Fan", type: .vent, isOn: false)]),
            
            Room(id: "5", name: "Garage", photo: "garage", devices: [
                Device(id: "501", name: "Overhead Light", type: .light, isOn: false),
                Device(id: "511", name: "Tool Bench Plug", type: .socket, isOn: false),
                Device(id: "521", name: "Garage Door Lock", type: .lock, isOn: false)]),
            
            Room(id: "6", name: "Garden", photo: "garden", devices: [
                Device(id: "601", name: "Garden Light", type: .light, isOn: false),
                Device(id: "621", name: "Gate Lock", type: .lock, isOn: false)])
        ]
    }
    
    private func loadScenes() {
        scenes = [
            HomeScene(label: "Morning", image: "morning-scene", action: { [weak self] in
                self?.triggerMorningScene()
            }),
            HomeScene(label: "Evening", image: "evening-scene", action: { [weak self] in
                self?.triggerEveningScene()
            }),
            HomeScene(label: "Night", image: "night-scene", action: { [weak self] in
                self?.triggerNightScene()
            })
        ]
    }
    
    func triggerMorningScene() {
        mqttManager.publish(topic: "home/scene/morning", with: "TRUE")
    }
    
    func triggerEveningScene() {
        mqttManager.publish(topic: "home/scene/evening", with: "TRUE")
    }
    
    func triggerNightScene() {
        mqttManager.publish(topic: "home/scene/night", with: "TRUE")
    }
}

