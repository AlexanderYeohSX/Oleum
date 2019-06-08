//
//  Constants.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 12/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import MapKit

struct ViewConstants {
    //Constants for UI Design
    
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
    //Constants for Firebase Database
    
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
    //Constants for battery status
    
    static let empty = "empty"
    static let high = "high"
    static let medium = "medium"
    static let low = "low"
    static let full = "full"
}

struct MapConstants {
    //Constants for all location for mock scenario
    
    static let spadesBurger = MapInfo(name: "Spades Burger", coord: CLLocationCoordinate2D(latitude: 3.074902 , longitude: 101.586458))
    static let canaiCafe = MapInfo(name: "Canai Cafe", coord:  CLLocationCoordinate2D(latitude: 3.075258 , longitude: 101.586465 ))
    static let nommsFriedChicken = MapInfo(name: "Nomm's", coord:  CLLocationCoordinate2D(latitude: 3.075292 , longitude: 101.587747 ))
    static let outdark = MapInfo(name: "Outdark", coord:  CLLocationCoordinate2D(latitude: 3.076414 , longitude: 101.589466 ))
    static let limFriedChicken = MapInfo(name: "Lim's Fried Chicken", coord: CLLocationCoordinate2D(latitude: 3.076117 , longitude: 101.589691))
    static let mcDonalds = MapInfo(name: "McDonald's", coord: CLLocationCoordinate2D(latitude: 3.073648, longitude: 101.590519 ))
    static let naughtyNuris = MapInfo(name: "Naughty Nuri's", coord: CLLocationCoordinate2D(latitude: 3.077521 , longitude: 101.586530))
    static let kentuckyFriedChicken = MapInfo(name: "KFC", coord: CLLocationCoordinate2D(latitude: 3.078228 , longitude: 101.588276))
    static let tryst = MapInfo(name: "Tryst", coord: CLLocationCoordinate2D(latitude: 3.077804 , longitude: 101.588293))
    static let oregi = MapInfo(name: "Oregi", coord: CLLocationCoordinate2D(latitude: 3.075833 , longitude: 101.588177))
    static let nasiKandarPelita = MapInfo(name: "Nasi Kandar Pelita", coord: CLLocationCoordinate2D(latitude: 3.076670 , longitude: 101.586464))
    static let rajsBananaLeaf = MapInfo(name: "Raj's Banana Leaf", coord: CLLocationCoordinate2D(latitude: 3.075954 , longitude: 101.586438))
    static let brewHouse = MapInfo(name: "The Brew House", coord: CLLocationCoordinate2D(latitude: 3.078014 , longitude: 101.587755))
    static let qBistroNasiKandar = MapInfo(name: "Q Bistro Nasi Kandar", coord: CLLocationCoordinate2D(latitude: 3.078297 , longitude: 101.588552))
    static let burgertory = MapInfo(name: "Burgertory", coord: CLLocationCoordinate2D(latitude: 3.073674 , longitude: 101.588084))
    static let silvaTandooriCorner = MapInfo(name: "Silva Tandoori Corner", coord: CLLocationCoordinate2D(latitude: 3.074065 , longitude: 101.587280))
    static let fortySixByProjectGibraltar = MapInfo(name: "46 By Project Gibraltar", coord: CLLocationCoordinate2D(latitude: 3.074095 , longitude: 101.590315))
    static let jibril = MapInfo(name: "JIBRIL", coord: CLLocationCoordinate2D(latitude: 3.075760 , longitude: 101.587241))
    static let carlsJr = MapInfo(name: "Carl's Jr", coord: CLLocationCoordinate2D(latitude: 3.074331 , longitude: 101.586919))
    static let littleBallyCafe = MapInfo(name: "Little Bally Cafe", coord: CLLocationCoordinate2D(latitude: 3.075315 , longitude: 101.588565))
    static let zoom: Float = 16.0
    static let ss15Center = CLLocationCoordinate2D(latitude: 3.076505, longitude: 101.588510)
    static let mapBoxApi: String = "pk.eyJ1IjoiYWxleGFuZGVyeWVvaCIsImEiOiJjanZxZmEzb2IwNnc2NDlueDRzdHA2dHowIn0.RcB7DsF-LUuXP2ORG9_ejw"
    
}

struct MapInfo {
    let name: String
    let coord: CLLocationCoordinate2D
}

extension Notification.Name {
    static let sensorsUpdated = Notification.Name("sensorsUpdated")
}


