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
    
    // Tutaj moze byc currentValueSubject
    var serverConnectionState = CurrentValueSubject<MQTTAppConnectionState, Never>(.disconnected)
    var topicSubject = PassthroughSubject<Topic, Never>()
    
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
        if let success = mqttClient?.connect(), success {
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
    
//    func isConnected() -> Bool {
//
//    }
    
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
            self.multipleSubscribe(topics: ["master/temperature"])
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        //        currentAppState.setReceivedMessage(text: message.string.description)
        
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
    case unknown
    
    init(message: CocoaMQTTMessage) {
        
        switch message.topic {
        case "master/temperature":
            self = .temperature(message.string ?? "")
            
        case "master/power":
            self = .power(message.string ?? "")
            
        default:
            self = .unknown
        }
    }
}
