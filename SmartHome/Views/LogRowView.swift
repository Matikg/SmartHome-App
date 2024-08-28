//
//  LogRowView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 27/08/2024.
//

import SwiftUI

struct LogRowView: View {
    let log: Log
    
    var body: some View {
        HStack {
            Image(log.device)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            Text(String(log.value))
            Text(log.time.formatted())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LogRowView(log: Log(time: Date(), value: 25.0, device: "thermostat"))
}
