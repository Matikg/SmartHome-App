//
//  IndicatorView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 20/08/2024.
//

import SwiftUI

struct IndicatorView: View {
    private let image: String
    private let label: String
    private let value: String
    
    init(image: String, label: String, value: String) {
        self.image = image
        self.label = label
        self.value = value
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(image)
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(label)
                    .bold()
                Text(value)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Capsule().fill(Color.gray))
        .foregroundStyle(.white)
    }
}

#Preview {
    IndicatorView(image: "thermostat", label: "Climate", value: "20 °C")
}
