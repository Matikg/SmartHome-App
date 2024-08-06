//
//  MQTTManager.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation
import CocoaMQTT
import Combine
import SwiftUI

final class MQTTManager: ObservableObject {
    var mqttClient: CocoaMQTT?
    var identifier: String!
    var host: String!
    var topic: String!
    var username: String!
    var password: String!
    
    // Tutaj moze byc currentValueSubject
    @Published var currentAppState = MQTTAppState()
    
    private var anyCancellable: AnyCancellable?
    
    init() {
        // Workaround to support nested Observables, without this code changes to state is not propagated
        anyCancellable = currentAppState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    
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
            currentAppState.setAppConnectionState(state: .connecting)
        } else {
            currentAppState.setAppConnectionState(state: .disconnected)
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
    
    func isConnected() -> Bool {
        return currentAppState.appConnectionState.isConnected
    }
    
    func connectionStateMessage() -> String {
        return currentAppState.appConnectionState.description
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
            currentAppState.setAppConnectionState(state: .connected)
            self.subscribe(topic: "master/temperature")
            self.multipleSubscribe(topics: ["master/temperature"])
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        //        currentAppState.setReceivedMessage(text: message.string.description)
//        guard let msgString = message.string else { return }
        
//        switch message.topic {
//        case "master/temperature":
////            DispatchQueue.main.async {
////                self.homeModel.temperature = msgString
////            }
//            
//            //currentTemperatureSubject
//        default:
//            print("Received message for an unhandled topic")
//        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        currentAppState.setAppConnectionState(state: .disconnected)
        
        // currentValueSubject.send(.disconnected)
    }
}


