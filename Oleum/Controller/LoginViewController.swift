//
//  LoginViewController.swift
//  OilOil
//
//  Created by Kean Wei Wong on 11/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var authenticationCode: String = "12345"
    private var loginSegue: String  = "LoginSegue"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        LevelSensorStore.shared.initializeFromFirebaseDatabase()
        print(LevelSensorStore.shared.levelSensorCache.keys)
        requestTacButton.layer.cornerRadius =  requestTacButton.layer.frame.height/2
        requestTacButton.layer.borderColor = ViewConstants.lineColor
        requestTacButton.layer.borderWidth = ViewConstants.lineWidth
        verifyButton.layer.cornerRadius = verifyButton.layer.frame.height/2
        verifyButton.layer.borderColor = ViewConstants.lineColor
        verifyButton.layer.borderWidth = ViewConstants.lineWidth


        print()
        
        self.navigationController?.navigationBar.barTintColor = ViewConstants.themeColor
        //self.navigationController?.navigationBar.
        for view in textFieldViews {
            view.layer.borderWidth = ViewConstants.lineWidth
            view.layer.cornerRadius = ViewConstants.cornerRadiusForViews
            view.layer.borderColor = ViewConstants.lineColor
        }
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        ///Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
        
    }
    

    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }


    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if authTextField.text == authenticationCode {
            performSegue(withIdentifier: loginSegue, sender: nil)
        } else {
            alertUser(title: "Invalid Authentication Code", message: "Please Try Again")
        }
    }
    
    
    @IBOutlet weak var authTextField: UITextField!
    
    
    
    @IBOutlet weak var requestTacButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet var textFieldViews: [UIView]!
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

