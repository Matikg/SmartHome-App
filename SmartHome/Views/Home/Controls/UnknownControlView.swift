//
//  UnknownControlView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct UnknownControlView: View {
    var body: some View {
        ControlGridCell(image: "", label: "") {
            EmptyView()
        }
    }
}

#Preview {
    UnknownControlView()
        .frame(width: 200, height: 200)
}
