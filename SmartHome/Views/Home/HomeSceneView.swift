//
//  HomeSceneView.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 21/08/2024.
//

import SwiftUI

struct HomeSceneView: View {
    private let scene: HomeScene
    private let isSelected: Bool
    private let onSelect: () -> Void
    
    init(scene: HomeScene, isSelected: Bool, onSelect: @escaping () -> Void) {
        self.scene = scene
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    var body: some View {
        Button(action: {
            self.onSelect()
        })  {
            HStack(alignment: .center) {
                Image(scene.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .padding(.leading, 5)
                
                Text(scene.label)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 150, height: 80)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.8))
            .cornerRadius(10)
            .foregroundColor(.white)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    HomeSceneView(scene: HomeScene(label: "Night", image: "night-scene", action: {
    }), isSelected: false, onSelect: { print("Scene selected") })
}
