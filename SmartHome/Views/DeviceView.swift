//
//  DeviceView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct DeviceView: View {
    
    @EnvironmentObject var homeModel: HomeModel
    var device: Device

    var body: some View {
        HStack {
//            Image(systemName: device.isOn ? "lightbulb.fill" : "lightbulb")
//                .foregroundColor(device.isOn ? .yellow : .gray)
            device.photo
                .resizable()
                .frame(width: 50, height: 50)
            Text(device.name)
                .bold()
            Spacer()
            Toggle(isOn: Binding(
                get: { device.isOn },
                set: { newValue in
                    if newValue != device.isOn {
                        homeModel.toggleDevice(withId: device.id)
                    }
                }
            )) {
                EmptyView()
            }
            .padding()
        }
        .frame(height: 60)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 15))
    }
}


#Preview {
    DeviceView(device: HomeModel().rooms[1].devices[1])
}

