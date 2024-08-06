//
//  ContentView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct ToolBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Home")
                    }
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            DeviceListView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "lightbulb.2.fill" : "lightbulb.2")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Devices")
                    }
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            AnalyticsView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                        Text("Analysis")
                    }
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
        }
    }
}

#Preview {
    ToolBarView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
        .environmentObject(SettingsViewModel(mqttManager: MQTTManager()))
}
