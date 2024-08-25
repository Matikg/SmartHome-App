//
//  HomeView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State var showingSettings = false
    @EnvironmentObject var homeModel: HomeModel
    @State var setButtonPressed = false
    let gradient = Gradient(colors: [.blue, .yellow, .orange, .red])
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            
                            IndicatorView(image: "thermostat", label: "Climate",
                                          value: "\(homeModel.temperature) °C")
                            
                            IndicatorView(image: "power", label: "Energy",
                                          value: "\(homeModel.power) kWh")
                            
                            IndicatorView(image: "light-bulb", label: "Lights",
                                          value: homeModel.numberOfDevicesOn(ofType: .light) == 0 ? "All Off" : "\(homeModel.numberOfDevicesOn(ofType: .light)) On")
                            
                            IndicatorView(image: "lock", label: "Security",
                                          value: homeModel.numberOfDevicesOn(ofType: .lock) == 0 ? "Disarmed" : "\(homeModel.numberOfDevicesOn(ofType: .lock)) Locked")
                        }
                        .frame(height: 100)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
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
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Controls")
                            .font(.headline)
                        
                        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                            GridRow {
                                ZStack(alignment: .top) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .shadow(radius: 5)
                                    
                                    VStack(spacing: 15) {
                                        HStack(alignment: .center, spacing: 1) {
                                            Image("thermos")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                            
                                            Text("Thermostat")
                                                .foregroundStyle(.white)
                                                .font(.title2)
                                                .bold()
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 5)
                                        .padding(.top, 15)
                                        .frame(height: 45)
                                        
                                        QDivider()
                                        
                                        Gauge(
                                            value: homeModel.setTemperature,
                                            in: homeModel.minTemperature...homeModel.maxTemperature,
                                            label: {
                                                Text("Temperature")
                                            },
                                            currentValueLabel: { Text("\(homeModel.setTemperature, format: .number)")
                                                .foregroundStyle(Color.white)},
                                            minimumValueLabel: { Text(homeModel.minTemperature, format: .number)
                                                .foregroundStyle(Color.white)},
                                            maximumValueLabel: { Text(homeModel.maxTemperature, format: .number)
                                                .foregroundStyle(Color.white)}
                                        )
                                        .gaugeStyle(.accessoryCircular)
                                        .tint(gradient)
                                        .scaleEffect(1.3)
                                        
                                        HStack {
                                            Stepper("Temperature", value: $homeModel.setTemperature, in: homeModel.minTemperature...homeModel.maxTemperature)
                                                .labelsHidden()
                                                .buttonRepeatBehavior(.enabled)
                                                .background(Color.blue, in: RoundedRectangle(cornerRadius: 5))
                                            
                                            Text("Set")
                                                .foregroundStyle(isDarkMode ? .white : .black)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal)
                                                .background(setButtonPressed ? (colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.7)) : Color.blue, in: RoundedRectangle(cornerRadius: 10))
                                                .background(Color.blue, in: RoundedRectangle(cornerRadius: 5))
                                                .simultaneousGesture(
                                                    DragGesture(minimumDistance: 0)
                                                        .onChanged { _ in
                                                            setButtonPressed = true
                                                        }
                                                        .onEnded { _ in
                                                            withAnimation(.easeOut(duration: 0.2)) {
                                                                setButtonPressed = false
                                                            }
                                                        }
                                                )
                                        }
                                    }
                                }
                                
                                ZStack(alignment: .top) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .shadow(radius: 5)
                                    
                                    VStack(spacing: 15) {
                                        HStack(alignment: .center, spacing: 1) {
                                            Image("sprinkler")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                            
                                            Text("Sprinkler")
                                                .foregroundStyle(.white)
                                                .font(.title2)
                                                .bold()
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 5)
                                        .padding(.top, 15)
                                        .frame(height: 45)
                                        
                                        QDivider()
                                    }
                                }
                            }
                            
                            GridRow {
                                ZStack(alignment: .top) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .shadow(radius: 5)
                                    
                                    VStack(spacing: 15) {
                                        HStack(alignment: .center, spacing: 1) {
                                            Image("gate")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                            
                                            Text("Garage")
                                                .foregroundStyle(.white)
                                                .font(.title2)
                                                .bold()
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 5)
                                        .padding(.top, 15)
                                        .frame(height: 45)
                                        
                                        QDivider()
                                    }
                                }
                                ZStack(alignment: .top) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .shadow(radius: 5)
                                    
                                    VStack(spacing: 15) {
                                        HStack(alignment: .center, spacing: 1) {
                                            
                                        }
                                        .padding(.horizontal, 5)
                                        .padding(.top, 15)
                                        .frame(height: 45)
                                        
                                        QDivider()
                                    }
                                }
                                
                            }
                        }
                        .frame(height: 400)
                    }
                    
                    Spacer()
                    
                }
                .settingsToolbar(showingSettings: $showingSettings, title: "My Home")
                .padding(.horizontal)
            }
            
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
