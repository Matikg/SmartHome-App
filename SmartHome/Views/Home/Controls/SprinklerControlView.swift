//
//  SprinklerControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct SprinklerControlView: View {
    var body: some View {
        ControlGridCell(image: "sprinkler", label: "Sprinkler") {
            EmptyView()
        }
    }
}

#Preview {
    SprinklerControlView()
        .frame(width: 200, height: 200)
}
