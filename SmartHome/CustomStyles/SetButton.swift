//
//  SetButton.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import SwiftUI

struct SetButton: View {
    let title: String
    @Binding var isPressed: Bool
    let colorScheme: ColorScheme
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    var action: () -> Void
    
    var body: some View {
        Text("Set")
            .foregroundStyle(isDarkMode ? .white : .black)
            .padding(.vertical, 6)
            .padding(.horizontal)
            .background(isPressed ? (colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.7)) : Color.blue, in: RoundedRectangle(cornerRadius: 10))
            .background(Color.blue, in: RoundedRectangle(cornerRadius: 5))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        withAnimation(.easeOut(duration: 0.2)) {
                            isPressed = false
                        }
                        action()
                    }
            )
    }
}

#Preview {
    SetButton(title: "Set", isPressed: .constant(false), colorScheme: .light) {
        print("Button pressed")
    }
}
