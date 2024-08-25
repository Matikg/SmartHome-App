//
//  AnalyticsView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct AnalyticsView: View {
    @State private var showingSettings = false
    @EnvironmentObject var homeModel: HomeModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Analytics View")
                    Text(homeModel.tempLog)
            }
            
                
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "Analysis")
        }
    }
}


#Preview {
    AnalyticsView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}

