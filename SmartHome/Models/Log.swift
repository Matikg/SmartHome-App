//
//  Log.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import Foundation

struct Log: Decodable, Identifiable {
    var id = UUID()
    let time: Date
    let value: String
    let device: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case value
        case device
    }
}
