//
//  ViewController.swift
//  OilOil
//
//  Created by Kean Wei Wong on 04/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class LevelStatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        barrelTableView.dataSource = self
        barrelTableView.delegate = self
    }

    
    @IBOutlet weak var barrelTableView: UITableView!
    
    
}

extension LevelStatusViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "barrelCell")!
            
            let backgroundView = cell.contentView.subviews[0]
            let levelLabel = cell.contentView.subviews[1]
            let collectedLabel = backgroundView.subviews.last!
            print(backgroundView.subviews)
            
            backgroundView.layer.cornerRadius = ViewConstants.cornerRadiusForTableCell
            backgroundView.layer.borderWidth = ViewConstants.lineWidth
            levelLabel.layer.cornerRadius = ViewConstants.cornerRadiusForLabel
            levelLabel.layer.borderColor = UIColor.black.cgColor
            levelLabel.layer.borderWidth = ViewConstants.lineWidth
            collectedLabel.layer.cornerRadius = collectedLabel.bounds.height/2
            collectedLabel.layer.borderWidth = ViewConstants.lineWidth
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 50.0
        
        if indexPath.row >= 1 {
            
            height = 80.0
            
        }
        
        return height
    }
}

struct ViewConstants {

    static let cornerRadiusForLabel:CGFloat = 25.0
    static let lineWidth: CGFloat = 1.0
    static let cornerRadiusForTableCell: CGFloat = 20.0
   
    
}
