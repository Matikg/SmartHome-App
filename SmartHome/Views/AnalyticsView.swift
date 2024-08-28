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
        NavigationStack {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(homeModel.logs, id: \.time) { log in
                            LogRowView(log: log)
                        }
                    }
                }
                .padding(.top)
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "Analysis")
        }
    }
}


#Preview {
    AnalyticsView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}

