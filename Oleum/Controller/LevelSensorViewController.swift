//
//  ViewController.swift
//  OilOil
//
//  Created by Kean Wei Wong on 04/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class LevelSensorViewController: UIViewController {

    let historySegue = "HistorySegue"
    var locationSelected: String = ModelConstants.noLocation
    private var levelSensorsAtLocation = [LevelSensor]()
    var tag: Int = 0;
    
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
      
    }
    
    func updateTableViewCell(forCell cell: UITableViewCell, withLevelSensor levelSensor: LevelSensor) {
        
        let backgroundView = cell.contentView.subviews[0]
        let levelLabel = cell.contentView.subviews[1] as! UILabel
        let collectedButton = backgroundView.subviews.last! as! UIButton
        
     
        
        backgroundView.layer.cornerRadius = ViewConstants.cornerRadiusForTableCell
        backgroundView.layer.borderWidth = ViewConstants.lineWidth
        
        levelLabel.text = levelSensor.tag
        levelLabel.layer.cornerRadius = ViewConstants.cornerRadiusForLabel
        levelLabel.layer.borderColor = UIColor.black.cgColor
        levelLabel.layer.borderWidth = ViewConstants.lineWidth
        
        collectedButton.layer.cornerRadius = collectedButton.bounds.height/2
        collectedButton.layer.borderWidth = ViewConstants.lineWidth
        collectedButton.contentMode = .scaleToFill
        collectedButton.imageView?.frame = ViewConstants.tickButtonImageFrame
    
        
        
    
    
        print(collectedButton.imageView?.frame)
         print(collectedButton.imageView?.image)
        
        
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cellTapped(sender:))))
        backgroundView.tag = tag
        tag += 1
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
}

