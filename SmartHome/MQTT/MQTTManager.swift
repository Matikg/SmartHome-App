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
    
    @EnvironmentObject var homeModel: HomeModel
    
    @Published var currentAppState = MQTTAppState()
    private var anyCancellable: AnyCancellable?
    //Private Init
    init() {
        // Workaround to support nested Observables, without this code changes to state is not propagated
        anyCancellable = currentAppState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    
    func initializeMQTT(host: String, identifier: String, username: String? = nil, password: String? = nil) {
        // If any previous instance exists then clean it
        if mqttClient != nil {
            mqttClient = nil
        }
        self.identifier = identifier
        self.host = host
        self.username = username
        self.password = password
        let clientID = "CocoaMQTT-\(identifier)-" + String(ProcessInfo().processIdentifier)
        
        // TODO: Guard
        mqttClient = CocoaMQTT(clientID: clientID, host: host, port: 1883)
        // If a server has username and password, pass it here
        if let finalusername = self.username, let finalpassword = self.password {
            mqttClient?.username = finalusername
            mqttClient?.password = finalpassword
        }
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
    
    
    func isSubscribed() -> Bool {
        return currentAppState.appConnectionState.isSubscribed
    }
    
    
    func isConnected() -> Bool {
        return currentAppState.appConnectionState.isConnected
    }
    
    
    func connectionStateMessage() -> String {
        return currentAppState.appConnectionState.description
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        currentAppState.setAppConnectionState(state: .connectedSubscribed)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        currentAppState.setAppConnectionState(state: .connectedUnSubscribed)
        currentAppState.clearData()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            currentAppState.setAppConnectionState(state: .connected)
            subscribe(topic: "master/temperature")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
//        currentAppState.setReceivedMessage(text: message.string.description)
        if let msgString = message.string, message.topic == "master/temperature" {
            homeModel.temperature = msgString
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        currentAppState.setAppConnectionState(state: .connectedUnSubscribed)
        currentAppState.clearData()
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        currentAppState.setAppConnectionState(state: .disconnected)
    }
}


