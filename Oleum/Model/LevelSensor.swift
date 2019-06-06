//
//  LevelSensor.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 12/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import Foundation

// Structure for LevelSensor
// 
// tag, batteryLevel & isConnected will be updated by sensor
// lastCollected & collectedBy will be updated by the mobile application.
// isFull will be updated by both sensor and mobile application

struct LevelSensor {
    var batteryLevel: String
    var collectedBy: String
    var isConnected: Bool
    var isFull: Bool
    var lastCollected: [Date]
    var tag: String
}
