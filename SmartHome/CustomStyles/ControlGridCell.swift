//
//  ControlGridCell.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct ControlGridCell<Content: View>: View {
    let image: String
    let label: String
    let content: Content
    
    init(image: String, label: String, @ViewBuilder content: () -> Content) {
        self.image = image
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .shadow(radius: 5)
            
            VStack(spacing: 15) {
                HStack(alignment: .center, spacing: 1) {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text(label)
                        .foregroundStyle(.white)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal, 5)
                .padding(.top, 15)
                .frame(height: 45)
                
                QDivider()
                
                content
            }
        }
    }
}
