//
//  Log.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 25/08/2024.
//

import Foundation

struct Log: Decodable {
    let time: String
    let value: Double
    let device: String
}
