//
//  GateControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct GateControlView: View {
    @EnvironmentObject var homeModel: HomeModel
    @Environment(\.colorScheme) var colorScheme
    @State private var openButtonPressed = false
    @State private var closedButtonPressed = false
    
    var body: some View {
        ControlGridCell(image: "gate", label: "Garage") {
            VStack(spacing: 0) {
                ProgressView("Operation in Progress", value: homeModel.operationProgress)
                    .labelsHidden()
                
                Text(homeModel.isGateOpen ? "Opened" : "Closed")
    
            }
            .padding(.horizontal)
            
            SetButton(title: "Open", isPressed: $openButtonPressed, colorScheme: colorScheme) {
                homeModel.openGarageGate()
            }
            SetButton(title: "Close", isPressed: $closedButtonPressed, colorScheme: colorScheme) {
                homeModel.closeGarageGate()
            }
            
        }
    }
}

#Preview {
    GateControlView()
        .frame(width: 200, height: 200)
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
