//
//  ViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 04/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit

//After the user selects a location, the user will be directed to the level sensors' page.
class LevelSensorViewController: UIViewController {

    let historySegue = ViewConstants.historySegue
    var locationSelected: String = ModelConstants.noLocation    //Default value for location selected is no location.
    private var levelSensorsAtLocation = [LevelSensor]()        //Initialize an array of level sensors
    var tagForCell: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Get the level sensor at the selected location.
        if locationSelected != ModelConstants.noLocation {
            if let levelSensorsFromStorage = LevelSensorStore.shared.getLevelSensors(at: locationSelected) {
                levelSensorsAtLocation = levelSensorsFromStorage
            }
        }
        
        //Set the data source and delegate of the table view to the class
        levelSensorTableView.dataSource = self
        levelSensorTableView.delegate = self
        locationLabel.text = locationSelected       //Set the label at the top of the page to be the name of the location selected
        
        listenForSensorChanges() //Call for the function that provides real-time update of the sensor in the location
    }
    
    func updateTableViewCell(forCell cell: UITableViewCell, withLevelSensor levelSensor: LevelSensor) {
        //Customization of each cells of the table view with the necessary information.
        
        //Defining constants for each view
        let backgroundView = cell.contentView.subviews[0]
        let levelLabel = cell.contentView.subviews[1] as! UILabel
        let batteryImageView = backgroundView.subviews[0] as! UIImageView
        let wifiImageView = backgroundView.subviews[1] as! UIImageView
        let dateLabel = backgroundView.subviews[2] as! UILabel
        let collectedButton = backgroundView.subviews.last! as! UIButton
        
        //Format of date to be displayed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        //Setting the connection status icon based on the level sensor isConnected property
        if levelSensor.isConnected {
            wifiImageView.image = UIImage(named: "Wifi")
        } else {
            wifiImageView.image = UIImage(named: "Wifi_Off")
        }
        
        //Setting the button icon and background color based on the level sensor isFull property
        if levelSensor.isFull {
            backgroundView.backgroundColor = #colorLiteral(red: 0.5529411765, green: 1, blue: 0.6117647059, alpha: 0.7)
            collectedButton.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.7921568627, blue: 0.337254902, alpha: 0.8)
             collectedButton.setImage(#imageLiteral(resourceName: "Tick"), for: .normal)
        } else {
            backgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            collectedButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            collectedButton.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
        }
        
        //Setting the battery icon based on the level sensor batteryLevel property
        switch levelSensor.batteryLevel {
        case BatteryLevelConstants.full:
            batteryImageView.image = UIImage(named:"Battery_Green")
        case BatteryLevelConstants.high:
            batteryImageView.image = UIImage(named:"Battery_Yellow")
        case BatteryLevelConstants.medium:
            batteryImageView.image = UIImage(named:"Battery_Orange")
        case BatteryLevelConstants.low:
            batteryImageView.image = UIImage(named:"Battery_Red")
        case BatteryLevelConstants.empty:
             batteryImageView.image = UIImage(named:"Battery")
        default:
            break
        }
        
        //Setting the display text based on the level sensor lastCollected property. The first value of lastCollected will be used for this text
        if let dateToDisplay = levelSensor.lastCollected.first {
            dateLabel.text = "Last Cleared on \(dateFormatter.string(from: dateToDisplay))"
        }
        
        //UI adjustments to improve user experience
        backgroundView.layer.cornerRadius = ViewConstants.cornerRadiusForTableCell
        backgroundView.layer.borderWidth = ViewConstants.lineWidth
        //Navigate to HistoryViewController of the sensor on clicking the cell.
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(sender:))))
        backgroundView.tag = self.tagForCell
        
        levelLabel.text = levelSensor.tag
        levelLabel.layer.cornerRadius = ViewConstants.cornerRadiusForLabel
        levelLabel.layer.borderColor = UIColor.black.cgColor
        levelLabel.layer.borderWidth = ViewConstants.lineWidth
        
        collectedButton.layer.cornerRadius = collectedButton.bounds.height/2
        collectedButton.layer.borderWidth = ViewConstants.lineWidth
        collectedButton.contentMode = .center
        collectedButton.imageEdgeInsets = ViewConstants.tickButtonImageInset
        collectedButton.addTarget(self, action: #selector(self.didCollected(_:)), for: .touchUpInside)
    
         self.tagForCell += 1
    }
    
    func reloadData() {
        //A function used to refresh the table view cell based on the latest levelSensors from levelSensorStore

         self.tagForCell = 0
        
        //Getting the level sensors from the level sensor storage for the location selected.
        if let levelSensorsFromStorage = LevelSensorStore.shared.getLevelSensors(at: locationSelected) {
            levelSensorsAtLocation = levelSensorsFromStorage
        }
        
        levelSensorTableView.reloadData()   //Reload the table view.
        
    }
    
    @objc func didCollected(_ sender:UIButton!){
        //Function that is called when the collected button is clicked.
        
        if let cellTag = sender.superview?.tag {
            
            //Only activates if the level sensor is full.
            if levelSensorsAtLocation[cellTag].isFull {
                
                levelSensorsAtLocation[cellTag].isFull = false  //Set the level sensor status to non-full
                levelSensorsAtLocation[cellTag].lastCollected.insert(Date(), at: 0)     //Add a date of collection
                performSegue(withIdentifier: historySegue, sender: cellTag)         //Directs the user to the HistoryViewController
                LevelSensorStore.shared.updateLevelSensor(at: locationSelected, for: levelSensorsAtLocation[cellTag])   //Updates Firebase for the sensor.
                reloadData()        //Reloads the table view cells
                
            }
            
        }
        
    }

    @IBOutlet weak var levelSensorTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
}

//Configuration of the table view
extension LevelSensorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levelSensorsAtLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
            cell = tableView.dequeueReusableCell(withIdentifier: "barrelCell")!
        
            let levelSensorAtCell = levelSensorsAtLocation[indexPath.row]
        
            updateTableViewCell(forCell: cell, withLevelSensor: levelSensorAtCell)
        
        if indexPath.row == levelSensorTableView.numberOfRows(inSection: 0){
             self.tagForCell = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 80.0
        return height
    }
    
    @objc func cellTapped(sender: UIGestureRecognizer){
        //Directs the user to the HistoryViewController whenever the cell is selected.
        performSegue(withIdentifier: historySegue, sender: sender.view?.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == historySegue {
            
            let selectedLevelSensorVC = segue.destination as? HistoryViewController
            
            if let selectedTag = sender as? Int {
                selectedLevelSensorVC?.levelSensorSelected = levelSensorsAtLocation[selectedTag]
            }
            
        }
    }
    
    func listenForSensorChanges(){
        //Changes the UI everytime there is an update on Firebase
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewForLatestSensorsData), name: .sensorsUpdated, object: nil)
    }
    
    @objc func updateViewForLatestSensorsData() {
        //Function called whenever there is an update on Firebase.
        
        //Get the changes from the local cache.
        if let levelSensorsFromStorage = LevelSensorStore.shared.getLevelSensors(at: locationSelected) {
            levelSensorsAtLocation = levelSensorsFromStorage
        }
        
        reloadData()        //Reloads the entire table view
    }
}

