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
            VStack(alignment: .center, spacing: 10) {
                
                Spacer()
                if homeModel.isGateOpen {
                    Label("Opened", systemImage: "door.garage.open")
                        .position(x: 80, y: -15)
                }
                else {
                    Label("Closed", systemImage: "door.garage.closed")
                        .position(x: 80, y: -15)
                }
                
                ProgressIndicator(progress: $homeModel.operationProgress, width: 145, height: 15)
                    .position(x: 82, y: -5)
            }
            .padding(.horizontal)
            
            HStack {
                SetButton(title: "Open", isPressed: $openButtonPressed, colorScheme: colorScheme) {
                    homeModel.openGarageGate()
                }
                .disabled(homeModel.isGateOpen)
                
                SetButton(title: "Close", isPressed: $closedButtonPressed, colorScheme: colorScheme) {
                    homeModel.closeGarageGate()
                }
                .disabled(!homeModel.isGateOpen)
            }
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    GateControlView()
        .frame(width: 200, height: 200)
        .environmentObject(HomeModel(mqttManager: MQTTManager()))
}
