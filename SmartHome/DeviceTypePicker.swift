//
//  DeviceTypePicker.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import SwiftUI

struct DeviceTypePicker: View {
    
    @Binding var currentDeviceType: DeviceType?
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button("All") {
                    currentDeviceType = nil
                }
                .buttonStyle(PickerButtonStyle(isSelected: currentDeviceType == nil))
                
                ForEach(DeviceType.allCases, id: \.self) { type in
                    Button {
                        currentDeviceType = type
                    } label: {
                            Image(type.image)
                            .resizable()
                            .scaledToFit()
                    }
                    .buttonStyle(PickerButtonStyle(isSelected: currentDeviceType == type))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PickerButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 30, height: 25)
            .padding(10)
            .background(isSelected ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}


#Preview {
    DeviceTypePicker(currentDeviceType: .constant(.light))
        .previewLayout(.sizeThatFits)
}

