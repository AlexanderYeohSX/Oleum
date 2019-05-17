//
//  LocationViewController.swift
//  OilOil
//
//  Created by Kean Wei Wong on 12/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    let levelSensorSegue = ViewConstants.levelSensorSegue
    var locationToDisplay: [String] = [] {
        didSet{
            locationTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.separatorColor = ViewConstants.lineUIColor
    
        locationView.layer.borderWidth = ViewConstants.lineWidth
        locationView.layer.cornerRadius = ViewConstants.cornerRadiusForViews
        
        searchView.layer.borderWidth = ViewConstants.lineWidth
        searchView.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        searchBar.delegate = self
        
        locationToDisplay = LevelSensorStore.shared.getAllLocation()
        
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            
            searchField.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
            searchField.layer.cornerRadius = 0
            searchField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14.0)!])
         
        }
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        ///Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
}

extension LocationViewController: UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
        cell.textLabel?.text = locationToDisplay[(indexPath.row)]
        print(cell)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let height:CGFloat = 54.0
        return height
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        locationToDisplay = LevelSensorStore.shared.getAllLocation()
        if searchText == "" {
            return
        }
        locationToDisplay = locationToDisplay.filter { locationString -> Bool in
            return locationString.lowercased().contains(searchText.lowercased())
        }
        
        
    }
}


