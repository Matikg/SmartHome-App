//
//  HomeView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct HomeView: View {
    @State var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
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
