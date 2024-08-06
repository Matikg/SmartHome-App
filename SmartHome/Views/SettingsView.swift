//
//  SettingsView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("MQTT Connection")) {
                    TextField("Host", text: $viewModel.host)
                    TextField("Client Identifier", text: $viewModel.identifier)
                    TextField("Username", text: $viewModel.username)
                    TextField("Password", text: $viewModel.password)
                    Button("Connect") {
                        viewModel.initialize()
                        viewModel.connect()
                    }
                    Button("Disconnect") {
                        viewModel.disconnect()
                    }
                }
                
//                Section(header: Text("Messaging")) {
//                    TextField("Topic", text: $viewModel.topic)
//                    TextField("Message", text: $viewModel.message)
//                    Button("Publish Message") {
//                        mqttManager.publish(topic: topic, with: message)
//                    }
//                    Button("Subscribe") {
//                        mqttManager.subscribe(topic: topic)
//                    }
//                    Button("Unsubscribe") {
//                        mqttManager.unSubscribeFromCurrentTopic()
//                    }
//                }
                
//                Section {
//                    Text(mqttManager.connectionStateMessage())
//                        .foregroundColor(mqttManager.isConnected() ? .green : .red)
//                }
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
        .environmentObject(SettingsViewModel(mqttManager: MQTTManager()))
}


