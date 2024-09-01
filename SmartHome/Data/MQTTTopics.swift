//
//  MQTTTopics.swift
//  SmartHome
//
//  Created by Mateusz Grudzień on 31/08/2024.
//

import Foundation

struct MQTTTopics {
    static let allTopics = [
        "master/temperature",
        "master/power",
        "master/temperature/set",
        "master/fan/set",
        "master/temperature/log",
        "garage/gate/status",
        "master/power/log",
        "master/fan/log"
    ]
}
