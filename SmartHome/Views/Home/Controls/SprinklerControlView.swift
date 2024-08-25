//
//  SprinklerControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct SprinklerControlView: View {
    @Binding var isSprinklerOn: Bool
    
    var body: some View {
        ControlGridCell(image: "sprinkler", label: "Sprinkler") {
            Toggle(isOn: $isSprinklerOn) {
                
            }
            Link("NodeRed", destination: URL(string: "https://192.168.0.12:1881")!)
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
    }
}

#Preview {
    SprinklerControlView(isSprinklerOn: .constant(false))
        .frame(width: 200, height: 200)
}
