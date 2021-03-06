//
//  LocationViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 12/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    let levelSensorSegue = ViewConstants.levelSensorSegue
    var locationToDisplay: [String] = [] {
        didSet{
            //Reloads the table view everytime the location updates.
            locationTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Configuring the table view
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.separatorColor = ViewConstants.lineUIColor
    
        //UI adjustments to improve user experience
        locationView.layer.borderWidth = ViewConstants.lineWidth
        locationView.layer.cornerRadius = ViewConstants.cornerRadiusForViews
        
        searchView.layer.borderWidth = ViewConstants.lineWidth
        searchView.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        //Configuring the search bar
        searchBar.delegate = self
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            
            searchField.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
            searchField.layer.cornerRadius = 0
            searchField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14.0)!])
            
        }
        
        locationToDisplay = LevelSensorStore.shared.getAllLocation()    //Configuring the necessary location to display
        
        //Dismiss keyboard when the user taps a non-text field part of the page.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
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

//Configuration of the table view
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


