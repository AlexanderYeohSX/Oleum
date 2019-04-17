//
//  SettingsViewController.swift
//  Oleum
//
//  Created by Kean Wei Wong on 16/04/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileView.layer.cornerRadius = ViewConstants.cornerRadiusForLabel
        profileView.layer.borderColor = ViewConstants.lineColor
        profileView.layer.borderWidth = ViewConstants.lineWidth
        
        checkInButton.layer.cornerRadius = checkInButton.layer.frame.height/2
        checkInButton.layer.borderColor = ViewConstants.lineColor
        checkInButton.layer.borderWidth = ViewConstants.lineWidth
        
        checkOutButton.layer.cornerRadius = checkOutButton.layer.frame.height/2
        checkOutButton.layer.borderColor = ViewConstants.lineColor
        checkOutButton.layer.borderWidth = ViewConstants.lineWidth
        
        for view in textFieldViews {
            view.layer.borderWidth = ViewConstants.lineWidth
            view.layer.cornerRadius = ViewConstants.cornerRadiusForViews
            view.layer.borderColor = ViewConstants.lineColor
        }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet var textFieldViews: [UIView]!
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
}
