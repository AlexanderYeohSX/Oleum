//
//  Constants.swift
//  Oleum
//
//  Created by Kean Wei Wong on 12/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import MapKit




struct ViewConstants {
    
    static let cornerRadiusForLabel:CGFloat = 25.0
    static let lineWidth: CGFloat = 1.0
    static let cornerRadiusForTableCell: CGFloat = 20.0
    static let cornerRadiusForViews: CGFloat = 10.0
    static let tickButtonImageInset: UIEdgeInsets = UIEdgeInsets(top: 9.5, left: 9.5, bottom: 9.5, right: 9.5)
    static let themeColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let lineColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let lineUIColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let historySegue: String = "HistorySegue"
    static let levelSensorSegue: String = "LevelSensorSegue"
    
}

struct DbConstants {
    
    static let location = "location"
    static let dbRef = Database.database().reference()
    static let locationRef = dbRef.child(location)
}

struct ModelConstants {
    
    static let noLocation = "No Location Available"
}

struct ImageAssets {
    
    let tick = "Tick"
}

struct BatteryLevelConstants {
    static let empty = "empty"
    static let high = "high"
    static let medium = "medium"
    static let low = "low"
    static let full = "full"
}

struct MapConstants {
    static let spadesBurger = MapInfo(name: "Spades Burger", coord: CLLocationCoordinate2D(latitude: 3.074902 , longitude: 101.586458))
    static let canaiCafe = MapInfo(name: "Canai Cafe", coord:  CLLocationCoordinate2D(latitude: 3.075258 , longitude: 101.586465 ))
    
    static let nommsFriedChicken = MapInfo(name: "Nomm's", coord:  CLLocationCoordinate2D(latitude: 3.075292 , longitude: 101.587747 ))
    
    static let outdark = MapInfo(name: "Outdark", coord:  CLLocationCoordinate2D(latitude: 3.076414 , longitude: 101.589466 ))
    
    static let limFriedChicken = MapInfo(name: "Lim's Fried Chicken", coord: CLLocationCoordinate2D(latitude: 3.076117 , longitude: 101.589691))
    
    
    static let zoom: Float = 75.0
    
    static let mapBoxApi: String = "pk.eyJ1IjoiYWxleGFuZGVyeWVvaCIsImEiOiJjanZxZmEzb2IwNnc2NDlueDRzdHA2dHowIn0.RcB7DsF-LUuXP2ORG9_ejw"
}

struct MapInfo {
    let name: String
    let coord: CLLocationCoordinate2D
}

extension Notification.Name {
    
    static let sensorsUpdated = Notification.Name("sensorsUpdated")
    
}


