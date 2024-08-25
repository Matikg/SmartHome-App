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
    @State private var setButtonPressed = false
    
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
                
                SetButton(title: "Set", isPressed: $setButtonPressed, colorScheme: colorScheme) {
                    print("Test1")
                }
            }
        }
    }
}

#Preview {
    ThermostatControlView()
        .frame(width: 200, height: 200)
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
