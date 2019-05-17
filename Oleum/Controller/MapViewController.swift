//
//  MapViewController.swift
//  Oleum
//
//  Created by Kean Wei Wong on 15/05/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit
import GoogleMaps
import MapboxDirections

class MapViewController: UIViewController {

    let initialLocation = MapConstants.spadesBurger
    let allRestaurants: [MapInfo] = [MapConstants.canaiCafe,MapConstants.spadesBurger,MapConstants.nommsFriedChicken,MapConstants.limFriedChicken,MapConstants.outdark]
    var routeMarkers: [GMSMarker] = []
    let directions = Directions(accessToken: MapConstants.mapBoxApi)
    var waypoints: [Waypoint] = []
    var options: RouteOptions = RouteOptions(waypoints: [Waypoint(coordinate: MapConstants.spadesBurger.coord)], profileIdentifier: .automobileAvoidingTraffic)
    let path = GMSMutablePath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !allRestaurants.isEmpty {
        
            let camera = GMSCameraPosition.camera(withTarget: (allRestaurants.first?.coord)!, zoom: MapConstants.zoom)
            routingMapView.camera = camera
            routingMapView.isTrafficEnabled = true
            //routingMapView.accessibilityElementsHidden = false
        }
        for restaurant in allRestaurants {
            let marker = GMSMarker()
            marker.position = restaurant.coord
            marker.title = restaurant.name
            marker.snippet = "SS15"
            marker.map = routingMapView
            marker.icon = GMSMarker.markerImage(with: .gray)
            routeMarkers.append(marker)
            
            let waypoint = Waypoint(coordinate: restaurant.coord)
            waypoints.append(waypoint)
        
        }
        
        
        routingMapView.layer.borderWidth = ViewConstants.lineWidth
        
        while waypoints.count >= 4 {
            
            drawDirection(for: [waypoints[0],waypoints[1],waypoints[2]])
            waypoints.removeFirst()
            waypoints.removeFirst()
        }
        
        if waypoints.count >= 2 && waypoints.count <= 4 {
            drawDirection(for: waypoints)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        
        
   
    }
    
    @IBOutlet weak var routingMapView: GMSMapView!
    
    func drawDirection(for waypoints:[Waypoint]){
        
        options = RouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
        
        let task = directions.calculate(options) { (waypoints, routes, error) in
            
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first, let leg = route.legs.first {
                
                
                if let collectionCoord = route.coordinates {
                    
                    for coord in collectionCoord {
                        self.path.add(coord)
                    }
                }
            }
            
            let polyline = GMSPolyline(path: self.path)
            polyline.map = self.routingMapView
            
        }
    }
    
}
