//
//  LocationViewController.swift
//  OilOil
//
//  Created by Kean Wei Wong on 12/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    let levelSensorSegue = "LevelSensorSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.layer.borderWidth = 1
        locationTableView.layer.cornerRadius = 10
        
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == levelSensorSegue {
            let locationCellSelected = sender as! UITableViewCell
            let lsvc = segue.destination as! LevelSensorViewController
            
            lsvc.locationSelected = locationCellSelected.textLabel?.text ?? ModelConstants.noLocation
            
        }
        
    }
    
    
    @IBOutlet weak var locationTableView: UITableView!
    
}

extension LocationViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LevelSensorStore.shared.numberOfLocation() + 1  //+1 for search cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
            cell.textLabel?.text = LevelSensorStore.shared.getAllLocation()[(indexPath.row - 1)] // minus search cell row.
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 50.0
        
        if indexPath.row >= 1 {
            
            height = 54.0
            
        }
        
        return height
    }
}
