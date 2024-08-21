//
//  Scene.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 21/08/2024.
//

import Foundation

struct HomeScene: Equatable {
    static func == (lhs: HomeScene, rhs: HomeScene) -> Bool {
        return lhs.label == rhs.label && lhs.image == rhs.image
    }
    
    var label: String
    var image: String
    var action: () -> Void
}
