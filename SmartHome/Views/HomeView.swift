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
    @EnvironmentObject var homeModel: HomeModel
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScrollView(.horizontal) {
                    
                    LazyHStack {
                        
                        HStack {
                                Image("thermostat")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading) {
                                    Text("Climate")
                                        .bold()
                                    Text("\(homeModel.temperature) C")
                                }
                            }
                            .padding(10)
                            .background(Capsule().fill(Color.black.opacity(0.5)))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                }
            }
            .settingsToolbar(showingSettings: $showingSettings, title: "My Home")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MQTTManager(homeModel: HomeModel()))
        .environmentObject(HomeModel())
}
