//
//  HistoryViewController.swift
//  Oleum
//
//  Created by Kean Wei Wong on 30/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
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
}

extension HistoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        var cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")!
        
        return cell
        
    }
    
    
    
}
