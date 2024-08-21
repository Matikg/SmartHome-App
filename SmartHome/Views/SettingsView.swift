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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("autoConnect") private var autoConnect: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("MQTT Connection")) {
                        HStack {
                            Image(systemName: "wifi.router")
                                .frame(width: 30)
                            TextField("Host", text: $viewModel.host)
                        }
                        
                        HStack {
                            Image(systemName: "person.text.rectangle")
                                .frame(width: 30)
                            TextField("Client Identifier", text: $viewModel.identifier)
                        }
                        
                        HStack {
                            Image(systemName: "person")
                                .frame(width: 30)
                            TextField("Username", text: $viewModel.username)
                        }
                        
                        HStack {
                            Image(systemName: "key")
                                .frame(width: 30)
                            SecureField("Password", text: $viewModel.password)
                        }
                        
                        Button("Connect") {
                            viewModel.connect()
                        }
                        .disabled(viewModel.serverState == .connected || viewModel.serverState == .connecting)
                        
                        Button("Disconnect") {
                            viewModel.disconnect()
                        }
                        .disabled(viewModel.serverState == .disconnected)
                    }
                    
                    Section(header: Text("Preferences")) {
                        HStack {
                            Image(systemName: "pencil")
                                .frame(width: 30)
                            Toggle("Dark Mode", isOn: $isDarkMode)
                        }
                        HStack {
                            Image(systemName: "autostartstop")
                                .frame(width: 30)
                            Toggle("Auto connect", isOn: $autoConnect)
                        }
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Image(systemName: viewModel.serverState.isConnected ? "wifi" : "wifi.slash")
                            .font(.title3)
                        Text(viewModel.serverState.rawValue)
                            .font(.title3)
                        Spacer()
                    }
                    .foregroundColor(viewModel.serverState.isConnected ? .green : .red)
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
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}


#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel(mqttManager: MQTTManager()))
}


