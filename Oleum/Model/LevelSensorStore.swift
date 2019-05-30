//
//  LevelSensorStore.swift
//  OilOil
//
//  Created by Kean Wei Wong on 12/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import Foundation
import FirebaseDatabase

class LevelSensorStore {
    
    static let shared = LevelSensorStore()
    var levelSensorCache = [String: [LevelSensor]]()

   
    
    init(){
        
    }
    
    func initializeFromFirebaseDatabase() {
        
        DbConstants.locationRef.observe(.value) { (snapshot) in
            if let locationsOfSensorFromDb = snapshot.value as? NSDictionary {
                for location in locationsOfSensorFromDb {
                    
                    let locationString = location.key as! String
                    print(locationString)
                    if let levelSensorsFromDb = location.value as? NSDictionary {
                        for levelSensor in levelSensorsFromDb {
                            
                            let levelSensorString = levelSensor.key as! String
                            if let sensorDataFromDb = levelSensor.value as? NSDictionary {
                                
                                
                                
                                if let batteryLevel = sensorDataFromDb["batteryLevel"] as? Int ,
                                    let collectedBy = sensorDataFromDb["collectedBy"] as? String,
                                    let isConnected = sensorDataFromDb["isConnected"] as? Bool,
                                    let isFull = sensorDataFromDb["isFull"] as? Bool {
                                    
                                    let batteryLevelString = self.batteryLevelIntToString(forValue: batteryLevel)
                                    var lastCollectedDate: [Date] = []
                                    
                                    
                                    if let lastCollected = sensorDataFromDb["lastCollected"] as? [Double] {
                                        for dateUnix in lastCollected {
                                            lastCollectedDate.append(Date(timeIntervalSince1970: dateUnix))
                                            
                                            
                                        }
                                    }
                                    
                                    print(lastCollectedDate)
                                    
                                    
                                    let newLevelSensor = LevelSensor(batteryLevel: batteryLevelString, collectedBy: collectedBy, isConnected: isConnected, isFull: isFull, lastCollected: lastCollectedDate, tag: levelSensorString)
                                    
                                    
                                    if self.levelSensorCache[locationString] != nil {
                                        
                                        self.updateLevelSensorFromDb(newSensor: newLevelSensor,at: locationString)
                                       
                                        
                                    } else {
                                        
                                        self.addLevelSensorFromDb(sensor: newLevelSensor,at: locationString)
                                       
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
                
                NotificationCenter.default.post(name: .sensorsUpdated, object: nil)
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
    
    func updateLevelSensor(at location: String, for sensorFromView: LevelSensor) {
    
        for levelSensor in levelSensorCache[location]! {
            
            if levelSensor.tag == sensorFromView.tag {
                
                let sensorIndex = getIndexOfSensor(withTag: levelSensor.tag, at: location)
                levelSensorCache[location]![sensorIndex] = sensorFromView
                
            }
            
            
        }
        updateFirebaseDatabase(for: sensorFromView, at: location)
        
        sortLevelSensors(at: location)
    }
    
    func batteryLevelIntToString(forValue batteryLevelInt:Int) -> String{
        
        var batteryLevelString:String = BatteryLevelConstants.empty
        switch batteryLevelInt {
        case _ where batteryLevelInt > 1000:
            batteryLevelString = BatteryLevelConstants.full
        case _ where batteryLevelInt >= 768:
        batteryLevelString = BatteryLevelConstants.high
        case _ where batteryLevelInt >= 512:
            batteryLevelString = BatteryLevelConstants.medium
        case _ where batteryLevelInt > 100:
            batteryLevelString = BatteryLevelConstants.low
        case _ where batteryLevelInt >= 0:
            batteryLevelString = BatteryLevelConstants.empty
        default:
            print("Error: Battery Level Not in Range")
        }
        
        return batteryLevelString
    }
    
    func updateLevelSensorFromDb(newSensor: LevelSensor, at location: String){
        
        var index = 0
        for sensor in levelSensorCache[location]! {
            
            if sensor.tag == newSensor.tag {
                
                levelSensorCache[location]![index] = newSensor
                return
                
            }
            
            index += 1
        }
        
        self.levelSensorCache[location]?.append(newSensor)
        
    }

    func addLevelSensorFromDb(sensor: LevelSensor, at location: String){
        
        levelSensorCache[location] = [sensor]
        
    }
    
    private func getIndexOfSensor(withTag tag: String, at location:String) -> Int {

        let levelSensors = levelSensorCache[location]!
        var sensorIndex = 0
        
        for index in 0 ... (levelSensors.count - 1) {
            if levelSensors[index].tag == tag {
                sensorIndex = index
            }
        }
        
        return sensorIndex
        
    }
    
    private func updateFirebaseDatabase(for sensor: LevelSensor, at location: String) {
        
        var dateUnixArray: [Int] = []
        
        for date in sensor.lastCollected {
            
            dateUnixArray.append(Int(date.timeIntervalSince1970))
        }
        DbConstants.locationRef.child(location).child(sensor.tag).child("isFull").setValue(sensor.isFull)
        DbConstants.locationRef.child(location).child(sensor.tag).child("lastCollected").setValue(dateUnixArray)

    }
}
