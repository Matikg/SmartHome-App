//
//  UnknownControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct AirControlView: View {
    @EnvironmentObject var homeModel: HomeModel
    @Environment(\.colorScheme) var colorScheme
    @State private var setButtonPressed = false
    @State private var selection = 2
    
    var body: some View {
        ControlGridCell(image: "fan", label: "Airflow") {
            Picker("", selection: $selection) {
                Text("Low").tag(1)
                Text("Auto").tag(2)
                Text("High").tag(3)
            }
            .pickerStyle(.segmented)
            .background(Color.blue, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 10)
            
            Slider(value: $homeModel.fanSpeed, in: 0...100, step: 1) {
            } minimumValueLabel: {
                Image(systemName: "fan.slash")
            } maximumValueLabel: {
                Image(systemName: "fan")
            }
            .padding(.horizontal, 10)

            SetButton(title: "Set", isPressed: $setButtonPressed, colorScheme: colorScheme) {
                homeModel.setFanSpeed()
            }
            .padding(.bottom, 15)
        }
    }
}

#Preview {
    AirControlView()
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
        .frame(width: 200, height: 200)
}


