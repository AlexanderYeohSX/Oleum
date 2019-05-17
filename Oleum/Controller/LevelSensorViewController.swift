//
//  ViewController.swift
//  OilOil
//
//  Created by Kean Wei Wong on 04/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class LevelSensorViewController: UIViewController {

    let historySegue = ViewConstants.historySegue
    var locationSelected: String = ModelConstants.noLocation
    private var levelSensorsAtLocation = [LevelSensor]() 
    var tagForCell: Int = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if locationSelected != ModelConstants.noLocation {
            
            if let levelSensorsFromStorage = LevelSensorStore.shared.getLevelSensors(at: locationSelected) {
                levelSensorsAtLocation = levelSensorsFromStorage
            }
        }
        barrelTableView.dataSource = self
        barrelTableView.delegate = self
        locationLabel.text = locationSelected
        
        listenForSensorChanges()
      
    }
    
    func updateTableViewCell(forCell cell: UITableViewCell, withLevelSensor levelSensor: LevelSensor) {
        
        let backgroundView = cell.contentView.subviews[0]
        let levelLabel = cell.contentView.subviews[1] as! UILabel
        let collectedButton = backgroundView.subviews.last! as! UIButton
        let wifiImageView = backgroundView.subviews[1] as! UIImageView
        let batteryImageView = backgroundView.subviews[0] as! UIImageView
        
        if levelSensor.isConnected {
            wifiImageView.image = UIImage(named: "Wifi")
        } else {
            wifiImageView.image = UIImage(named: "Wifi_Off")
        }
        
        if levelSensor.isFull {
            backgroundView.backgroundColor = #colorLiteral(red: 0.5529411765, green: 1, blue: 0.6117647059, alpha: 0.7)
            collectedButton.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.7921568627, blue: 0.337254902, alpha: 0.8)
             collectedButton.setImage(#imageLiteral(resourceName: "Tick"), for: .normal)
        } else {
            backgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            collectedButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            collectedButton.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
        }
        
        
        
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
        
        
        backgroundView.layer.cornerRadius = ViewConstants.cornerRadiusForTableCell
        backgroundView.layer.borderWidth = ViewConstants.lineWidth
        
        levelLabel.text = levelSensor.tag
        levelLabel.layer.cornerRadius = ViewConstants.cornerRadiusForLabel
        levelLabel.layer.borderColor = UIColor.black.cgColor
        levelLabel.layer.borderWidth = ViewConstants.lineWidth
        
        
        collectedButton.layer.cornerRadius = collectedButton.bounds.height/2
        collectedButton.layer.borderWidth = ViewConstants.lineWidth
        collectedButton.contentMode = .center
        collectedButton.imageEdgeInsets = ViewConstants.tickButtonImageInset
        
        collectedButton.addTarget(self, action: #selector(self.didCollected(_:)), for: .touchUpInside)
    
    
        
        
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(sender:))))
        
        backgroundView.tag = tagForCell
    
        
        tagForCell += 1
    }
    
    func reloadData() {
        
        tagForCell = 0
        
        if let levelSensorsFromStorage = LevelSensorStore.shared.getLevelSensors(at: locationSelected) {
            levelSensorsAtLocation = levelSensorsFromStorage
        }
        
        barrelTableView.reloadData()
        
    }
    
    @objc func didCollected(_ sender:UIButton!)
    {
        if let cellTag = sender.superview?.tag {
            
            if levelSensorsAtLocation[cellTag].isFull {
                
                levelSensorsAtLocation[cellTag].isFull = false
                levelSensorsAtLocation[cellTag].lastCollected.append(Date())
                performSegue(withIdentifier: historySegue, sender: cellTag)
                LevelSensorStore.shared.updateLevelSensor(at: locationSelected, for: levelSensorsAtLocation[cellTag])
                reloadData()
                
            }
            
        }
        
    }

    @IBOutlet weak var barrelTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
}

extension LevelSensorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levelSensorsAtLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
            cell = tableView.dequeueReusableCell(withIdentifier: "barrelCell")!
        
            let levelSensorAtCell = levelSensorsAtLocation[indexPath.row]
        
            updateTableViewCell(forCell: cell, withLevelSensor: levelSensorAtCell)
        
        if indexPath.row == barrelTableView.numberOfRows(inSection: 0){
            tagForCell = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 80.0
        
        return height
    }
    
    @objc func cellTapped(sender: UIGestureRecognizer){

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewForLatestSensorsData), name: .sensorsUpdated, object: nil)
    }
    
    @objc func updateViewForLatestSensorsData() {
        if let levelSensorsFromStorage = LevelSensorStore.shared.getLevelSensors(at: locationSelected) {
            levelSensorsAtLocation = levelSensorsFromStorage
        }
        
        reloadData()
    }
}

