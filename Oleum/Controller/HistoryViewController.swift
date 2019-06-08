//
//  HistoryViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 30/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit

//When the user clicks on the sensor in the LevelSensorViewController, the user will be directed into this page.
class HistoryViewController: UIViewController {

    var levelSensorSelected: LevelSensor?   //Defining variable for the selected level sensor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set the heading as the level sensor tag
        levelSensorLabel.text = levelSensorSelected?.tag
        
        //Setup of the table view
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.layer.borderWidth = ViewConstants.lineWidth
        historyTableView.layer.borderColor = ViewConstants.lineColor
        historyTableView.layer.cornerRadius = ViewConstants.cornerRadiusForViews
        historyTableView.separatorColor = ViewConstants.lineUIColor
        
        //Setting the battery icon based on the level sensor batteryLevel property
        switch levelSensorSelected!.batteryLevel {
        case BatteryLevelConstants.full:
            batteryHorizontalImageView.image = UIImage(named:"Battery_Horizontal_Green")
        case BatteryLevelConstants.high:
            batteryHorizontalImageView.image = UIImage(named:"Battery_Horizontal_Yellow")
        case BatteryLevelConstants.medium:
            batteryHorizontalImageView.image = UIImage(named:"Battery_Horizontal_Orange")
        case BatteryLevelConstants.low:
            batteryHorizontalImageView.image = UIImage(named:"Battery_Horizontal_Red")
        case BatteryLevelConstants.empty:
            batteryHorizontalImageView.image = UIImage(named:"Battery_Horizontal")
        default:
            break
        }
        
        //Setting the wifi icon based on the level sensor isConnected property
        if levelSensorSelected!.isConnected {
            WifiImageView.image = UIImage(named: "Wifi")
        } else {
            WifiImageView.image = UIImage(named: "Wifi_Off")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //reloads the table view everytime this view appears
        historyTableView.reloadData()
    }
 
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var levelSensorLabel: UILabel!
    @IBOutlet weak var batteryHorizontalImageView: UIImageView!
    @IBOutlet weak var WifiImageView: UIImageView!
    
}

//Configuration of the table view
extension HistoryViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dateCount = levelSensorSelected?.lastCollected.count {
            return dateCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Date format for this page
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")!
        
        let dateCollectedLabel = cell.contentView.subviews[0] as! UILabel
        let collectedByLabel = cell.contentView.subviews[1] as! UILabel

        if let dateToDisplay = levelSensorSelected?.lastCollected[indexPath.row] {
            dateCollectedLabel.text = dateFormatter.string(from: dateToDisplay)
        }
    
        collectedByLabel.text = "Collected by \(levelSensorSelected?.collectedBy ?? "Kean Wei")"
        
        return cell
        
    }

}
