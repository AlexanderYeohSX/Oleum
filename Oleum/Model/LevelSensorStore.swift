//
//  LevelSensorStore.swift
//  OilOil
//
//  Created by Kean Wei Wong on 12/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import Foundation

class LevelSensorStore {
    
    static let shared = LevelSensorStore()
    var levelSensorCache = [String: [LevelSensor]]()
    
    init(){        
    }
    
    func initializeFromFirebaseDatabase() {
        
        DbConstants.locationRef.observeSingleEvent(of: .value) { (snapshot) in
            if let locationsOfSensorFromDb = snapshot.value as? NSDictionary {
                for location in locationsOfSensorFromDb {
                    
                    let locationString = location.key as! String
                    print(locationString)
                    if let levelSensorsFromDb = location.value as? NSDictionary {
                        for levelSensor in levelSensorsFromDb {
                            
                            let levelSensorString = levelSensor.key as! String
                            if let sensorDataFromDb = levelSensor.value as? NSDictionary {
                                
                                if let batteryLevel = sensorDataFromDb["batteryLevel"] as? String ,
                                    let collectedBy = sensorDataFromDb["collectedBy"] as? String,
                                    let isConnected = sensorDataFromDb["isConnected"] as? Bool,
                                    let isFull = sensorDataFromDb["isFull"] as? Bool,
                                    let lastCollected = sensorDataFromDb["lastCollected"] as? String {
                                
                                    if (self.levelSensorCache[locationString] != nil) {
                                        
                                        self.levelSensorCache[locationString]?.append((LevelSensor(tag: levelSensorString, batteryLevel: batteryLevel, collectedBy: collectedBy, isConnected: isConnected, isFull: isFull, lastCollected: lastCollected)))
                                        
                                    } else {
                                    self.levelSensorCache[locationString] = [(LevelSensor(tag: levelSensorString, batteryLevel: batteryLevel, collectedBy: collectedBy, isConnected: isConnected, isFull: isFull, lastCollected: lastCollected))]
                                    }
                                    
                                    self.sortLevelSensors(at: locationString)
                                    
                                 
                                    
//                                    self.levelSensorCache[locationString]?.sort() { frontLevelSensor,backLevelSensor in
//                                        
//                                        return frontLevelSensor.isFull
//                                    }
                                }
                            }
                        }
                    }
                }
                
                print(self.levelSensorCache.keys)
                
                
            } else {
                print("No Data Obtained From Firebase")
            }
            
        }
    }
    
    func numberOfLocation() -> Int {
        
        return levelSensorCache.count
    }
    
    func getAllLocation() -> [String] {
    
        var locations = [String]()
        
        for location in levelSensorCache.keys {
            
            locations.append(location)
            
        }
        
        return locations
    }
    
    func getLevelSensors(at location: String) -> [LevelSensor]? {
        
            return levelSensorCache[location]
        
    }
    
    func sortLevelSensors(at location:String){
        
        levelSensorCache[location]!.sort() { frontLevelSensor,backLevelSensor in
            
            let frontSensorEndChar = String(frontLevelSensor.tag[frontLevelSensor.tag.index(before: frontLevelSensor.tag.endIndex)])
            let backSensorEndChar = String(backLevelSensor.tag[backLevelSensor.tag.index(before: backLevelSensor.tag.endIndex)])
            
            if frontLevelSensor.isFull != backLevelSensor.isFull {
                return frontLevelSensor.isFull
            }
            
            return (Int(frontSensorEndChar)) ?? 0 < (Int(backSensorEndChar)) ?? 0
        }
        
    }
    
    func updateLevelSensor(at location: String, for levelSensors: [LevelSensor]) {
    
        levelSensorCache[location] = levelSensors
        
        sortLevelSensors(at: location)
    }
    
    
}
