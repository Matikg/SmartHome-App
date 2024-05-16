//
//  SettingsView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var mqttManager: MQTTManager
    @State private var host: String = "192.168.22.112"
    @State private var identifier: String = "iOS Device"
    @State private var topic: String = ""
    @State private var message: String = ""
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("MQTT Connection")) {
                    TextField("Host", text: $host)
                    TextField("Client Identifier", text: $identifier)
                    TextField("Username", text: $username)
                    TextField("Password", text: $password)
                    Button("Connect") {
                        mqttManager.initializeMQTT(host: host, identifier: identifier, username: "BarMat", password: "test")
                        mqttManager.connect()
                    }
                    Button("Disconnect") {
                        mqttManager.disconnect()
                    }
                }
                
                Section(header: Text("Messaging")) {
                    TextField("Topic", text: $topic)
                    TextField("Message", text: $message)
                    Button("Publish Message") {
                        mqttManager.publish(topic: topic, with: message)
                    }
                    Button("Subscribe") {
                        mqttManager.subscribe(topic: topic)
                    }
                    Button("Unsubscribe") {
                        mqttManager.unSubscribeFromCurrentTopic()
                    }
                }
                
                Section {
                    if mqttManager.isSubscribed() {
                        Text("Subscribed to topic: \(mqttManager.topic ?? "Unknown")")
                    }
                    Text("Received message: \(mqttManager.currentAppState.receivedMessage)")
                    Text(mqttManager.connectionStateMessage())
                        .foregroundColor(mqttManager.isConnected() ? .green : .red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    SettingsView()
        .environmentObject(MQTTManager(homeModel: HomeModel()))
}


