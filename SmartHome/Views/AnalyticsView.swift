//
//  AnalyticsView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct AnalyticsView: View {
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Analytics View")
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "Analysis")
        }
        
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(MQTTManager())
        .environmentObject(HomeModel())
}

