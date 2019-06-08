//
//  MapViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 15/05/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit
import GoogleMaps
import MapboxDirections

class MapViewController: UIViewController {

    // Route for All Location
    let allRestaurants: [MapInfo] = [MapConstants.mcDonalds,MapConstants.burgertory,MapConstants.carlsJr,MapConstants.silvaTandooriCorner,MapConstants.fortySixByProjectGibraltar,MapConstants.spadesBurger,MapConstants.nommsFriedChicken,MapConstants.littleBallyCafe,MapConstants.limFriedChicken,MapConstants.oregi,MapConstants.jibril,MapConstants.canaiCafe,MapConstants.outdark,MapConstants.naughtyNuris,MapConstants.brewHouse,MapConstants.nasiKandarPelita,MapConstants.rajsBananaLeaf,MapConstants.tryst,MapConstants.kentuckyFriedChicken,MapConstants.qBistroNasiKandar]
    
    var distance: Double = 0 {
        didSet {
             print("Total Distance: \(distance)") //Distance calculation variable
        }
    }
    //Variables required for map customization
    var routeMarkers: [GMSMarker] = []
    let directions = Directions(accessToken: MapConstants.mapBoxApi)
    var waypoints: [Waypoint] = []
    var options: RouteOptions = RouteOptions(waypoints: [Waypoint(coordinate: MapConstants.spadesBurger.coord)], profileIdentifier: .automobile)
    let path = GMSMutablePath()
    let downloadGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Zooms the map to SS15
        if !allRestaurants.isEmpty {
            let camera = GMSCameraPosition.camera(withTarget: MapConstants.ss15Center, zoom: MapConstants.zoom)
            routingMapView.camera = camera
            routingMapView.isTrafficEnabled = true
        }
        
        //Adds a marker for each restaurant in the allRestaurants array, also set a waypoint for the distance calculation and route planning
        for restaurant in allRestaurants {
            let marker = GMSMarker()
            let waypoint = Waypoint(coordinate: restaurant.coord)
            
            marker.position = restaurant.coord
            marker.title = restaurant.name
            marker.snippet = "SS15"
            marker.map = routingMapView
            marker.icon = GMSMarker.markerImage(with: .lightGray)
            
            routeMarkers.append(marker)
            waypoints.append(waypoint)
        }
    
        routingMapView.layer.borderWidth = ViewConstants.lineWidth
        
        //Since Mapbox only allows a maximum of 3 points per navigation, the navigation must be done in a progressive manner, removing the first 2 points after navigation, and the last point is the start of the new navigation. This repeats itself until all the location had been navigated to.
        if waypoints.count >= 4 {
            
            drawDirection(for: [waypoints[0],waypoints[1],waypoints[2]])
            waypoints.removeFirst()
            waypoints.removeFirst()
            
        } else if self.waypoints.count >= 2 && self.waypoints.count <= 4 {
            
            self.drawDirection(for: self.waypoints)
        }
        
        self.repeatingWaypointCalls()
      
    }
    
    func drawDirection(for waypoints:[Waypoint]){
        //a function to draw the route on the map
        
        options = RouteOptions(waypoints: waypoints, profileIdentifier: .automobile)
        downloadGroup.enter()
        
        let task = directions.calculate(options) { (waypoints, routes, error) in
            //callback function for mapbox navigation
            
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first, let leg = route.legs.first {
                
                if let collectionCoord = route.coordinates {
                    
                    for coord in collectionCoord {
                        self.path.add(coord)
                        print(coord)
                        
                    }
                    
                    print("Distance: \(route.distance)")
                    self.distance += Double(route.distance)
        
                }
            }
            
            let polyline = GMSPolyline(path: self.path)
            polyline.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            polyline.strokeWidth = CGFloat(integerLiteral: 3)
            polyline.map = self.routingMapView
            
            self.downloadGroup.leave()
            
        }
        
    }
    
    func repeatingWaypointCalls(){
        //repeats the navigation until all waypoint had been completed.
        
        downloadGroup.notify(queue: .main) {
            
            if self.waypoints.count >= 4 {
                
                self.drawDirection(for: [self.waypoints[0],self.waypoints[1],self.waypoints[2]])
                self.waypoints.removeFirst()
                self.waypoints.removeFirst()
                self.repeatingWaypointCalls()
                
            } else if self.waypoints.count >= 2 && self.waypoints.count <= 4 {
                
                self.drawDirection(for: self.waypoints)
                
            }
            
        }
        
    }
    
    @IBOutlet weak var routingMapView: GMSMapView!
    
}
