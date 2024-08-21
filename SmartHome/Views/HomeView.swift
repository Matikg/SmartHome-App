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
            VStack(alignment: .leading) {
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
                    .frame(height: 100)
                }
                
                Text("Scenes")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(homeModel.scenes.indices, id: \.self) { index in
                            let scene = homeModel.scenes[index]
                            HomeSceneView(scene: scene, isSelected: scene == homeModel.selectedScene,
                                          onSelect: {
                                if homeModel.selectedScene != scene {
                                    homeModel.selectedScene = scene
                                    scene.action() // Trigger the scene's action
                                } else {
                                    // If the scene is already selected, just deselect it
                                    homeModel.selectedScene = nil
                                }
                            })
                            
                        }
                    }
                    .frame(height: 100)
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
