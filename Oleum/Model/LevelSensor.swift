//
//  LevelSensor.swift
//  OilOil
//
//  Created by Kean Wei Wong on 12/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import Foundation

// Structure for LevelSensor
// 
// batteryLevel, isConnected & isFull will be updated by sensor
// lastCollected,

struct LevelSensor {
    
    var batteryLevel: String
    var collectedBy: String
    var isConnected: Bool
    var isFull: Bool
    var lastCollected: [Date]
    var tag: String
}
