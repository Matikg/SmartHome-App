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
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(homeModel.logs, id: \.value) { log in
                            HStack {
                                Text(log.device)
                                Text(String(log.value))
                                Text(log.time)
                            }
                            .padding(.horizontal)
                        }
                    }
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

