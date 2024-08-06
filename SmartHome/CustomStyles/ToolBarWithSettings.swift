//
//  ToolBarWithSettings.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/04/2024.
//

import Foundation
import SwiftUI

struct ToolbarWithSettings: ViewModifier {
    @Binding var showingSettings: Bool
    let title: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .padding()
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
    }
}

extension View {
    func settingsToolbar(showingSettings: Binding<Bool>, title: String) -> some View {
        self.modifier(ToolbarWithSettings(showingSettings: showingSettings, title: title))
    }
}
