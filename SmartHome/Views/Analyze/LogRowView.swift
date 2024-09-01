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
                .frame(width: 50, height: 50)
                .padding(.leading)
            Text("\(String(Int(log.value))) \(log.unit)")
            Spacer()
            Label(log.time.formatted(), systemImage: "calendar")
                .padding(.trailing)
        }
        .foregroundStyle(.white)
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.blue).gradient) // Background color
                .shadow(radius: 2) // Optional: add a shadow
        )
        .padding(.horizontal, 30)
    }
}

#Preview {
    LogRowView(log: Log(time: Date(), value: 25.0, device: "thermostat", unit: "%"))
}
