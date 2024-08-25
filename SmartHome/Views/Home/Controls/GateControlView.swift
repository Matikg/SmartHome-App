//
//  GateControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct GateControlView: View {
    var body: some View {
        ControlGridCell(image: "gate", label: "Garage") {
            EmptyView()
        }
    }
}

#Preview {
    GateControlView()
        .frame(width: 200, height: 200)
}
