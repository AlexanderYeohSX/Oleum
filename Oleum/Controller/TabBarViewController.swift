//
//  TabBarViewController.swift
//  Oleum
//
//  Created by Kean Wei Wong on 30/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    
    override func viewDidLoad() {

        super.viewDidLoad()

        tabBar.layer.borderWidth = ViewConstants.lineWidth
        tabBar.layer.borderColor = ViewConstants.lineColor
        tabBarController?.selectedIndex = 2
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
