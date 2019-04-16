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
    static let tickButtonImageFrame: CGRect = CGRect(x: 9.5, y: 12.0, width: 16.0, height: 11.0)
    
    
}

struct DbConstants {
    
    static let location = "location"
    static let dbRef = Database.database().reference()
    static let locationRef = dbRef.child(location)
}

struct ModelConstants {
    
    static let noLocation = "No Location Available"
}
