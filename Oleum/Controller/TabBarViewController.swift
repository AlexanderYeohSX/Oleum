//
//  TabBarViewController.swift
//  Oleum
//
//  Created by Alexander Yeoh Shi Xian on 30/03/2019.
//  Copyright © 2019 Alexander Yeoh Shi Xian. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        //UI adjustments to improve user experience
        tabBar.layer.borderWidth = ViewConstants.lineWidth
        tabBar.layer.borderColor = ViewConstants.lineColor
        tabBarController?.selectedIndex = 2
    }
}
