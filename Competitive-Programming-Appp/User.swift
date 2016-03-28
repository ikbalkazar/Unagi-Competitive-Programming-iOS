//
//  User.swift
//  Unagi
//
//  Created by Harun Gunaydin on 3/25/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var objectId: String!
    var profilePicture: UIImage!
    
    init() {
        
        objectId = ""
        profilePicture = nil
        
    }
    
    init(id: String, profilePicture: UIImage ) {
        
        self.objectId = id
        self.profilePicture = profilePicture
        
    }
    
}