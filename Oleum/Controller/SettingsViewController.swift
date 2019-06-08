//
//  SettingsViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 16/04/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit

//Class for the settings tab
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         //UI adjustments to improve user experience
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
        
        for textField in settingsTextFields {
            textField.borderStyle = .none
        }
        
        //Dismiss keyboard when the user taps a non-text field part of the page.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBOutlet weak var profileView: UIView!
    @IBOutlet var textFieldViews: [UIView]!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet var settingsButtons: [UIBarButtonItem]!
    @IBOutlet var settingsTextFields: [UITextField]!
}
