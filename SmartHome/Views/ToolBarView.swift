//
//  ContentView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct ToolBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
            
            DeviceListView()
                .tabItem {
                    VStack {
                        Image(systemName: "lightbulb.2.fill")
                        Text("Devices")
                    }
                }
            
            AnalyticsView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.xyaxis.line")
                        Text("Analysis")
                    }
                }
        }
    }
}

#Preview {
    ToolBarView()
        .environmentObject(HomeModel())
        .environmentObject(MQTTManager(homeModel: HomeModel()))
}
