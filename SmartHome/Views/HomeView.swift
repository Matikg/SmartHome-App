//
//  HomeView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct HomeView: View {
    @State var showingSettings = false
    @EnvironmentObject var mqttManager: MQTTManager
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ZStack {
                        Capsule()
                            .frame(width: 120, height: 50)
                        HStack {
                            Image(systemName: "air.purifier")
                                .foregroundStyle(.blue)
                                .font(.title2)
                            
                            VStack {
                                Text("Climate")
                                if mqttManager.topic == "master/temperature" {
                                    
                                    Text("\(mqttManager.currentAppState.receivedMessage) C")
                                }
                                
                            }
                            .foregroundStyle(.white)
                        }
                    }
                    ZStack {
                        Capsule()
                            .frame(width: 120, height: 50)
                        HStack {
                            Image("light-bulb")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            
                            
                            VStack {
                                Text("Lights")
                                
                                Text("3 On")
                            }
                            .foregroundStyle(.white)
                        }
                    }
                    ZStack {
                        Capsule()
                            .frame(width: 120, height: 50)
                        HStack {
                            Image("lock")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            
                            
                            VStack {
                                Text("Security")
                                
                                Text("1 Unlocked")
                            }
                            .foregroundStyle(.white)
                        }
                    }
                }
                .foregroundStyle(.gray)
                Button(action: {
                    mqttManager.subscribe(topic: "master/temperature")
                    mqttManager.publish(topic: "master/temperature", with: "CHECK")
                    
                }, label: {
                    Text("Button")
                })
                
                
                Text("Received message: \(mqttManager.currentAppState.receivedMessage)")
                Spacer()
                Text("Home View")
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "My Home")
        }
        
    }
    
}

#Preview {
    HomeView()
        .environmentObject(MQTTManager())
        .environmentObject(HomeModel())
}
