//
//  ThermostatControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct ThermostatControlView: View {
    @EnvironmentObject var homeModel: HomeModel
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @Binding var setButtonPressed: Bool
    
    let gradient = Gradient(colors: [.blue, .yellow, .orange, .red])
    
    var body: some View {
        ControlGridCell(image: "thermos", label: "Thermostat") {
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
}

#Preview {
    ThermostatControlView(setButtonPressed: .constant(false))
        .frame(width: 200, height: 200)
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
