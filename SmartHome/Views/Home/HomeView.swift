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
    @State private var isSprinklerOn = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    // MARK: Indicators
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            Spacer().frame(width: 5)
                            
                            IndicatorView(image: "thermostat", label: "Climate",
                                          value: "\(homeModel.temperature) °C")
                            
                            IndicatorView(image: "power", label: "Energy",
                                          value: "\(homeModel.power) kWh")
                            
                            IndicatorView(image: "light-bulb", label: "Lights",
                                          value: homeModel.numberOfDevicesOn(ofType: .light) == 0 ? "All Off" : "\(homeModel.numberOfDevicesOn(ofType: .light)) On")
                            
                            IndicatorView(image: "lock", label: "Security",
                                          value: homeModel.numberOfDevicesOn(ofType: .lock) == 0 ? "Disarmed" : "\(homeModel.numberOfDevicesOn(ofType: .lock)) Locked")
                            
                            Spacer().frame(width: 5)
                        }
                        .frame(height: 100)
                    }
                    .shadow(radius: 5)
                    
                    // MARK: Scenes
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Scenes")
                            .font(.headline)
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                Spacer().frame(width: 5)
                                
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
                                
                                Spacer().frame(width: 5)
                            }
                            .frame(height: 100)
                        }
                    }
                    
                    // MARK: Controls
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Controls")
                            .font(.headline)
                        
                        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                            GridRow {
                                ThermostatControlView()
                                
                                SprinklerControlView()
                            }
                            
                            GridRow {
                                GateControlView()
                                
                                AirControlView()
                            }
                        }
                        .frame(height: 400)
                    }
                    .padding(.horizontal)
                }
                .settingsToolbar(showingSettings: $showingSettings, title: "My Home")
            }
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
