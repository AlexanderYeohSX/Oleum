//
//  LoginViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 11/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var authenticationCode: String = "12345"
    private var loginSegue: String  = "LoginSegue"
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if loginScrollView.superview!.layer.frame.height >= 600 {
            
            loginScrollView.isScrollEnabled = false
        }
        
        // Do any additional setup after loading the view.
        loginScrollView.delegate = self
        registerForKeyboardNotifications()
        LevelSensorStore.shared.initializeFromFirebaseDatabase()
        requestTacButton.layer.cornerRadius =  requestTacButton.layer.frame.height/2
        requestTacButton.layer.borderColor = ViewConstants.lineColor
        requestTacButton.layer.borderWidth = ViewConstants.lineWidth
        verifyButton.layer.cornerRadius = verifyButton.layer.frame.height/2
        verifyButton.layer.borderColor = ViewConstants.lineColor
        verifyButton.layer.borderWidth = ViewConstants.lineWidth
        
        self.navigationController?.navigationBar.barTintColor = ViewConstants.themeColor
        
        //self.navigationController?.navigationBar.shadowImage = UIColor.black.as1ptImage()

        for view in textFieldViews {
            view.layer.borderWidth = ViewConstants.lineWidth
            view.layer.cornerRadius = ViewConstants.cornerRadiusForViews
            view.layer.borderColor = ViewConstants.lineColor
        }
        
        for textField in loginTextFields {
            textField.borderStyle = .none
        }
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        
        // Uncomment the line below if you want the tap not not interfere and cancel other interactions.
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


    //MARK: - Interaction
    @objc func keyboardWillBeShown(notification: NSNotification){
        
        loginScrollView.isScrollEnabled = true
        
        if let info = notification.userInfo, let keyboardFrameEndUserInfoKey = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            var keyboardRect: CGRect = keyboardFrameEndUserInfoKey.cgRectValue
            keyboardRect = self.view.convert(keyboardRect, from: nil)
            let keyboardTop = keyboardRect.origin.y
            
            var newScrollViewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: keyboardTop)
            newScrollViewFrame.size.height = keyboardTop - self.view.bounds.origin.y
            self.loginScrollView.frame = newScrollViewFrame
            
            if let _activeField = self.activeField {
                
                
                
                var frameToDisplay = CGRect(x: _activeField.frame.minX, y: _activeField.frame.minY, width: _activeField.frame.width, height: _activeField.frame.height + 50)
              
                self.loginScrollView.scrollRectToVisible(frameToDisplay, animated: true)
            }
            
        }
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        
        let defaultFrame = CGRect(x: self.loginScrollView.frame.origin.x, y: self.loginScrollView.frame.origin.y, width: self.view.frame.size.width, height:  self.view.frame.size.height)
        
        if loginScrollView.superview!.layer.frame.height >= 600 {
            
            loginScrollView.isScrollEnabled = false
        }
        
        self.loginScrollView.frame = defaultFrame
        let topFrame = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)
        self.loginScrollView.scrollRectToVisible(topFrame, animated: true)
        
        activeField = nil
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if authTextField.text == authenticationCode {
            performSegue(withIdentifier: loginSegue, sender: nil)
        } else {
            alertUser(title: "Invalid Authentication Code", message: "Please Try Again")
        }
    }
    
    
    
    @IBOutlet var loginTextFields: [UITextField]!
    
    @IBOutlet weak var authTextField: UITextField!
    @IBOutlet weak var loginScrollView: UIScrollView!
    
    
    @IBOutlet weak var requestTacButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet var textFieldViews: [UIView]!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension LoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillBeShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        activeField = textField
        
    }
}


extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

