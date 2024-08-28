//
//  ProgressIndicator.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 28/08/2024.
//

import SwiftUI

struct ProgressIndicator: View {
    @Binding var progress: Double
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .stroke()
                .frame(width: width + 10, height: height + 10)
                .foregroundStyle(.blue)
                
            RoundedRectangle(cornerRadius: 5)
                .frame(width: progress * width, height: height)
                .foregroundStyle(.blue)
                .offset(x: 5)
        }
    }
}
