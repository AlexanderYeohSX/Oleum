//
//  HistoryViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 30/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    var levelSensorSelected: LevelSensor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        levelSensorLabel.text = levelSensorSelected?.tag
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.layer.borderWidth = ViewConstants.lineWidth
        historyTableView.layer.borderColor = ViewConstants.lineColor
        historyTableView.layer.cornerRadius = ViewConstants.cornerRadiusForViews
        historyTableView.separatorColor = ViewConstants.lineUIColor
        
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
        if levelSensorSelected!.isConnected {
            WifiImageView.image = UIImage(named: "Wifi")
        } else {
            WifiImageView.image = UIImage(named: "Wifi_Off")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        historyTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var levelSensorLabel: UILabel!
    
    @IBOutlet weak var batteryHorizontalImageView: UIImageView!
    
    @IBOutlet weak var WifiImageView: UIImageView!
    
}

extension HistoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dateCount = levelSensorSelected?.lastCollected.count {
        return dateCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
