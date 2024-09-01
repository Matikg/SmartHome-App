//
//  QDivider.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct QDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.black.opacity(0.7))
            .blur(radius: 1)
            .padding(.horizontal, 5)
    }
}

#Preview {
    QDivider()
}
