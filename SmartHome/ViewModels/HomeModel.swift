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
    @Published var logs = [Log]()
    @Published var selectedDate = Date()
    @Published var operationProgress = 0.0
    @Published var isGateOpen = false
    @Published var isGateOperating = false
    @Published var fanSpeed = 0.0
    
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
                case .fanSpeed(let value):
                    self.fanSpeed = Double(value) ?? 0.0
                case .tempLog(let logs):
                    self.logs.removeAll()
                    self.logs.append(contentsOf: logs)
                case .powerLog(let logs):
                    self.logs.append(contentsOf: logs)
                case .fanLog(let logs):
                    self.logs.append(contentsOf: logs)
                case .tempSet(let value):
                    self.setTemperature = Double(value) ?? 0.0
                case .garageGate(let status):
                    self.isGateOpen = Bool(status) ?? false
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
        if let url = Bundle.main.url(forResource: "rooms", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                rooms = try decoder.decode([Room].self, from: data)
            }
            catch {
                print("Error loading JSON data: \(error)")
            }
        }
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
    
    func setHomeTemperature() {
        mqttManager.publish(topic: "master/temperature/set", with: String(setTemperature))
    }
    
    func setFanSpeed() {
        mqttManager.publish(topic: "master/fan/set", with: String(fanSpeed))
    }
    
    func scheduleWatering() {
        let isoDateFormatter = ISO8601DateFormatter()
        let scheduledTime = isoDateFormatter.string(from: selectedDate)
        let message = """
        {
            "device": "sprinkler",
            "action": "schedule",
            "time": "\(scheduledTime)"
        }
        """
        mqttManager.publish(topic: "garden/sprinkler/schedule", with: message)
    }
    
    func openGarageGate() {
        isGateOperating = true
        mqttManager.publish(topic: "garage/gate/control", with: "TRUE")
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.operationProgress += 0.02
            if self.operationProgress >= 1.0 {
                self.isGateOperating = false
                timer.invalidate()
                self.operationProgress = 0.0
            }
        }
    }
    
    func closeGarageGate() {
        isGateOperating = true
        mqttManager.publish(topic: "garage/gate/control", with: "FALSE")
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.operationProgress += 0.02
            if self.operationProgress >= 1.0 {
                self.isGateOperating = false
                timer.invalidate()
                self.operationProgress = 0.0
            }
        }
    }
}

