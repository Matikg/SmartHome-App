//
//  HomeView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct HomeView: View {
    @State var showingSettings = false
    @EnvironmentObject var homeModel: HomeModel
    @State private var temp = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    LazyHStack(spacing: 10) {
                        // Tutaj dodac frame na wysokosc
                        HStack {
                            Image("thermostat")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Climate")
                                    .bold()
                                Text("20 °C")
                            }
                        }
                        .padding(10)
                        .background(Capsule().fill(Color.black.opacity(0.5)))
                        .foregroundStyle(.white)
                        
                        HStack {
                            Image("power")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Energy")
                                    .bold()
                                Text("112.6 kWh")
                            }
                        }
                        .padding(10)
                        .background(Capsule().fill(Color.black.opacity(0.5)))
                        .foregroundStyle(.white)
                        
                        HStack {
                            Image("light-bulb")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Lights")
                                    .bold()
                                Text("6 On")
                            }
                        }
                        .padding(10)
                        .background(Capsule().fill(Color.black.opacity(0.5)))
                        .foregroundStyle(.white)
                        
                        HStack {
                            Image("lock")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Security")
                                    .bold()
                                Text("6 Locked")
                            }
                        }
                        .padding(10)
                        .background(Capsule().fill(Color.black.opacity(0.5)))
                        .foregroundStyle(.white)
                    }
                }
                .settingsToolbar(showingSettings: $showingSettings, title: "My Home")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        Rectangle()
                            .frame(width: 150, height: 80)
                        Rectangle()
                            .frame(width: 150, height: 80)
                        Rectangle()
                            .frame(width: 150, height: 80)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
