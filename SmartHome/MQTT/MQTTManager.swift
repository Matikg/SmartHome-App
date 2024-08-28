//
//  MQTTManager.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import CocoaMQTT
import Combine
import SwiftUI

final class MQTTManager {
    var mqttClient: CocoaMQTT?
    var identifier: String!
    var host: String!
    var topic: String!
    var username: String!
    var password: String!
    
    var serverConnectionState = CurrentValueSubject<MQTTAppConnectionState, Never>(.disconnected)
    var topicSubject = PassthroughSubject<Topic, Never>()
    var connectionErrorMessage = PassthroughSubject<String, Never>()
    
    func initializeMQTT(host: String, identifier: String, username: String? = nil, password: String? = nil) {
        // Clean any previous MQTT connection
        if mqttClient != nil {
            mqttClient = nil
        }
        self.identifier = identifier
        self.host = host
        self.username = username
        self.password = password
        
        let clientID = "CocoaMQTT-\(identifier)-" + String(ProcessInfo().processIdentifier)
        
        mqttClient = CocoaMQTT(clientID: clientID, host: host, port: 1883)
        
        // Setting up username and password if they exist
        if let finalusername = self.username, let finalpassword = self.password {
            mqttClient?.username = finalusername
            mqttClient?.password = finalpassword
        }
        // Additional setup
        mqttClient?.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        mqttClient?.keepAlive = 60
        mqttClient?.delegate = self
    }
    
    func connect() {
        if let success = mqttClient?.connect(timeout: 5.0), success {
            serverConnectionState.send(.connecting)
        } else {
            serverConnectionState.send(.connected)
        }
    }
    
    func subscribe(topic: String) {
        self.topic = topic
        mqttClient?.subscribe(topic, qos: .qos1)
    }
    
    func multipleSubscribe(topics: [String]) {
        topics.forEach { topic in
            mqttClient?.subscribe(topic, qos: .qos1)
        }
    }
    
    func publish(topic: String ,with message: String) {
        mqttClient?.publish(topic, withString: message, qos: .qos1)
    }
    
    func disconnect() {
        mqttClient?.disconnect()
    }
    
    func unSubscribe(topic: String) {
        mqttClient?.unsubscribe(topic)
    }
    
    func unSubscribeFromCurrentTopic() {
        mqttClient?.unsubscribe(topic)
    }
    
    func currentHost() -> String? {
        return host
    }
}

// MARK: - MQTT Delegates

extension MQTTManager: CocoaMQTTDelegate {
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            serverConnectionState.send(.connected)
            connectionErrorMessage.send("")
            self.multipleSubscribe(topics: ["master/temperature", "master/power", "master/temperature/set", "master/fan/set", "master/temperature/log", "garage/gate/status", "master/power/log"])
            publish(topic: "synchronize", with: "update")
            publish(topic: "logs", with: "update")
        }
        else {
            let errorMessage = "Failed to connect: \(ack.description)"
            connectionErrorMessage.send(errorMessage)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        topicSubject.send(Topic(message: message))
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        serverConnectionState.send(.disconnected)
    }
}

enum Topic {
    case temperature(String)
    case power(String)
    case tempSet(String)
    case fanSpeed(String)
    case tempLog([Log])
    case garageGate(String)
    case powerLog(String)
    case unknown
    
    init(message: CocoaMQTTMessage) {
        switch message.topic {
        case "master/temperature":
            self = .temperature(message.string ?? "")
            
        case "master/fan/set":
            self = .fanSpeed(message.string ?? "")
            
        case "master/power":
            self = .power(message.string ?? "")
            
        case "master/power/log":
            self = .powerLog(message.string ?? "")
            
        case "master/temperature/log":
            print(message.string ?? "NIE")
            if let string = message.string, let jsonData = string.data(using: .utf8) {
                
                // Create a JSONDecoder instance
                let decoder = JSONDecoder()
                
                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)
                    return isoFormatter.date(from: dateStr) ?? Date()
                    
                }
                
                
                do {
                    let logs = try decoder.decode([Log].self, from: jsonData)
                    self = .tempLog(logs)
                    
                } catch {
                    print("Failed to decode JSON: \(error)")
                    self = .tempLog([])
                }
                
            } else {
                self = .tempLog([])
            }
            
        case "master/temperature/set":
            self = .tempSet(message.string ?? "")
            
        case "garage/gate/status":
            self = .garageGate(message.string ?? "")
            
        default:
            self = .unknown
        }
    }
}
