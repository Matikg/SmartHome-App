//
//  SprinklerControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct SprinklerControlView: View {
    @EnvironmentObject var homeModel: HomeModel
    @Environment(\.colorScheme) var colorScheme
    @State private var scheduleButtonPressed = false
    
    var body: some View {
        ControlGridCell(image: "sprinkler", label: "Sprinkler") {
            VStack {
                Spacer()
                
                GeometryReader { geo in
                    DatePicker("Schedule Watering", selection: $homeModel.selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.blue.opacity(0.5)))
                        .scaleEffect(0.9)
                        .frame(width: geo.size.width)
                }
                
                SetButton(title: "Schedule", isPressed: $scheduleButtonPressed, colorScheme: colorScheme) {
                    homeModel.scheduleWatering()
                }
            }
            .padding(.bottom, 15)
        }
    }
}

#Preview {
    SprinklerControlView()
        .frame(width: 200, height: 200)
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
