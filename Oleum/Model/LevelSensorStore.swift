//
//  LevelSensorStore.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 12/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import Foundation
import FirebaseDatabase

//Level sensor cache class instance.
class LevelSensorStore {
    
    static let shared = LevelSensorStore()
    var levelSensorCache = [String: [LevelSensor]]()
    
    init(){
    }
    
    //Obtain data from Google Firebase
    func initializeFromFirebaseDatabase() {
        
        DbConstants.locationRef.observe(.value) { (snapshot) in
           //Closure returned after data was downloaded from Firebase.
            
            //location key in Firebase
            if let locationsOfSensorFromDb = snapshot.value as? NSDictionary {
               
                for location in locationsOfSensorFromDb {
                    
                    let locationString = location.key as! String
                    
                    //level sensor key in Firebase
                    if let levelSensorsFromDb = location.value as? NSDictionary {
                    
                        for levelSensor in levelSensorsFromDb {
                            
                            let levelSensorString = levelSensor.key as! String
                            if let sensorDataFromDb = levelSensor.value as? NSDictionary {
                                
                                
                                 //value of battery level, collector, connection status and container level status of the sensor returned.
                                if let batteryLevel = sensorDataFromDb["batteryLevel"] as? Int ,
                                    let collectedBy = sensorDataFromDb["collectedBy"] as? String,
                                    let isConnected = sensorDataFromDb["isConnected"] as? Bool,
                                    let isFull = sensorDataFromDb["isFull"] as? Bool {
                                    
                                    //Converts Battery level into string of battery status.
                                    let batteryLevelString = self.batteryLevelIntToString(forValue: batteryLevel)
                                    var lastCollectedDate: [Date] = []
                                    
                                    //Change date from Unix integer into date format.
                                    if let lastCollected = sensorDataFromDb["lastCollected"] as? [Double] {
                                        for dateUnix in lastCollected {
                                            lastCollectedDate.append(Date(timeIntervalSince1970: dateUnix))
                                        }
                                    }
                                    
                                    //Create a new level sensor constant to be added into the cache.
                                    let newLevelSensor = LevelSensor(batteryLevel: batteryLevelString, collectedBy: collectedBy, isConnected: isConnected, isFull: isFull, lastCollected: lastCollectedDate, tag: levelSensorString)
                                    
                                    //Add the new level sensor into the cache.
                                    if self.levelSensorCache[locationString] != nil {
                                        self.updateLevelSensorFromDb(newSensor: newLevelSensor,at: locationString)
                                    } else {
                                        self.addLevelSensorFromDb(sensor: newLevelSensor,at: locationString)
                                    }
                                
                                   //sort the level sensors
                                    self.sortLevelSensors(at: locationString)
                                }
                            }
                        }
                    }
                }
                
                //Add a notification to ensure that the view updates whenever there is an update to Firebase.
                NotificationCenter.default.post(name: .sensorsUpdated, object: nil)
            
            } else {
                print("No Data Obtained From Firebase")
            }
        }
    }
    
    //Return the number of location in the database from the level sensor cache
    func numberOfLocation() -> Int {
        return levelSensorCache.count
    }
    
    //Return all location in the database from the level sensor cache.
    func getAllLocation() -> [String] {
        var locations = [String]()
        for location in levelSensorCache.keys {
            locations.append(location)
        }
        return locations
    }
    
    //Return all of the level sensors at the specified location
    func getLevelSensors(at location: String) -> [LevelSensor]? {
        return levelSensorCache[location]
    }
    
    //Sort the level sensors at the specified location. The sensors are sort based on the tag number and whether if it is full.
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
    
    //Update the level sensor at the given location with the data from phone.
    func updateLevelSensor(at location: String, for sensorFromView: LevelSensor) {
    
        for levelSensor in levelSensorCache[location]! {
            if levelSensor.tag == sensorFromView.tag {
                let sensorIndex = getIndexOfSensor(withTag: levelSensor.tag, at: location)
                levelSensorCache[location]![sensorIndex] = sensorFromView
            }
        }
        
        //Update Firebase for the selected sensor
        updateFirebaseDatabase(for: sensorFromView, at: location)
        
        //The sensor is sort again due to changes made to the data.
        sortLevelSensors(at: location)
    }
    
    //Converts battery level integer into level status based on the range of the battery level that it is currently in.
    func batteryLevelIntToString(forValue batteryLevelInt:Int) -> String{
        
        var batteryLevelString:String = BatteryLevelConstants.empty
        
        //The level status is full if the battery level is above 1000, high if it is abbove 768, medium if it is above 512, low if it is above 100 and empty for those below 100.
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
    
    //Update the level sensor cache based on data from Firebase.
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

    //Add a new level sensor from database.
    func addLevelSensorFromDb(sensor: LevelSensor, at location: String){
        levelSensorCache[location] = [sensor]
    }
    
    //Return the index of the sensor with the given tag at a location
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
    
    //Update the Firebase database for the given sensor updated for the cache.
    private func updateFirebaseDatabase(for sensor: LevelSensor, at location: String) {
        var dateUnixArray: [Int] = []
        for date in sensor.lastCollected {
            dateUnixArray.append(Int(date.timeIntervalSince1970))
        }
        DbConstants.locationRef.child(location).child(sensor.tag).child("isFull").setValue(sensor.isFull)
        DbConstants.locationRef.child(location).child(sensor.tag).child("lastCollected").setValue(dateUnixArray)
    }
}
