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
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        
                        IndicatorView(image: "thermostat", label: "Climate",
                                      value: "\(homeModel.temperature) °C")
                        
                        IndicatorView(image: "power", label: "Energy",
                                      value: "\(homeModel.power) kWh")
                        
                        IndicatorView(image: "light-bulb", label: "Lights",
                                      value: homeModel.numberOfDevicesOn(ofType: .light) == 0 ? "Off" : "\(homeModel.numberOfDevicesOn(ofType: .light)) On")
                        
                        IndicatorView(image: "lock", label: "Security",
                                      value: homeModel.numberOfDevicesOn(ofType: .lock) == 0 ? "Unlocked" : "\(homeModel.numberOfDevicesOn(ofType: .lock)) Locked")
                    }
                }
                .frame(height: 100)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        Rectangle()
                            .frame(width: 150, height: 80)
                        Rectangle()
                            .frame(width: 150, height: 80)
                        Rectangle()
                            .frame(width: 150, height: 80)
                    }
                    .foregroundStyle(.gray)
                }
                
                
                
                
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "My Home")
            .padding(.horizontal)
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
