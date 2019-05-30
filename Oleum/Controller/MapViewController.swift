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
//  let allRestaurants: [MapInfo] = [MapConstants.mcDonalds,MapConstants.burgertory,MapConstants.spadesBurger,MapConstants.limFriedChicken,MapConstants.outdark,MapConstants.qBistroNasiKandar,MapConstants.kentuckyFriedChicken,MapConstants.nasiKandarPelita]
    
    //Route for selected sensors
   //let allRestaurants: [MapInfo] = [MapConstants.mcDonalds,MapConstants.burgertory,MapConstants.spadesBurger,MapConstants.nommsFriedChicken,MapConstants.littleBallyCafe,MapConstants.limFriedChicken,MapConstants.oregi,MapConstants.jibril,MapConstants.outdark,MapConstants.naughtyNuris,MapConstants.nasiKandarPelita,MapConstants.tryst,MapConstants.kentuckyFriedChicken,MapConstants.qBistroNasiKandar]
    
    //  Route for All Location
     let allRestaurants: [MapInfo] = [MapConstants.mcDonalds,MapConstants.burgertory,MapConstants.carlsJr,MapConstants.silvaTandooriCorner,MapConstants.fortySixByProjectGibraltar,MapConstants.spadesBurger,MapConstants.nommsFriedChicken,MapConstants.littleBallyCafe,MapConstants.limFriedChicken,MapConstants.oregi,MapConstants.jibril,MapConstants.canaiCafe,MapConstants.outdark,MapConstants.naughtyNuris,MapConstants.brewHouse,MapConstants.nasiKandarPelita,MapConstants.rajsBananaLeaf,MapConstants.tryst,MapConstants.kentuckyFriedChicken,MapConstants.qBistroNasiKandar]
    
    var distance: Double = 0 {
        didSet {
             print("Total Distance: \(distance)")
        }
    }
    var routeMarkers: [GMSMarker] = []
    let directions = Directions(accessToken: MapConstants.mapBoxApi)
    var waypoints: [Waypoint] = []
    var options: RouteOptions = RouteOptions(waypoints: [Waypoint(coordinate: MapConstants.spadesBurger.coord)], profileIdentifier: .automobileAvoidingTraffic)
    let path = GMSMutablePath()
    let downloadGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !allRestaurants.isEmpty {
        
            let camera = GMSCameraPosition.camera(withTarget: MapConstants.ss15Center, zoom: MapConstants.zoom)
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
            marker.icon = GMSMarker.markerImage(with: .lightGray)
            routeMarkers.append(marker)
            
            let waypoint = Waypoint(coordinate: restaurant.coord)
            waypoints.append(waypoint)
        
        }
        
        
        routingMapView.layer.borderWidth = ViewConstants.lineWidth
        
       
        if waypoints.count >= 4 {
            
            drawDirection(for: [waypoints[0],waypoints[1],waypoints[2]])
            waypoints.removeFirst()
            waypoints.removeFirst()
            
        } else if self.waypoints.count >= 2 && self.waypoints.count <= 4 {
            
            self.drawDirection(for: self.waypoints)
        }
        
        self.repeatingWaypointCalls()

      
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
        
        options = RouteOptions(waypoints: waypoints, profileIdentifier: .automobile)
        
        downloadGroup.enter()
       
      
        
        let task = directions.calculate(options) { (waypoints, routes, error) in
            
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
    
}
