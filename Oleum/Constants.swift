//
//  Constants.swift
//  Oleum
//
//  Created by Kean Wei Wong on 12/03/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct ViewConstants {
    
    static let cornerRadiusForLabel:CGFloat = 25.0
    static let lineWidth: CGFloat = 1.0
    static let cornerRadiusForTableCell: CGFloat = 20.0
    static let cornerRadiusForViews: CGFloat = 10.0
    static let tickButtonImageInset: UIEdgeInsets = UIEdgeInsets(top: 12.0, left: 9.5, bottom: 12.0, right: 9.5)
    static let themeColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let lineColor: CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
}

struct DbConstants {
    
    static let location = "location"
    static let dbRef = Database.database().reference()
    static let locationRef = dbRef.child(location)
}

struct ModelConstants {
    
    static let noLocation = "No Location Available"
}
