//
//  Website.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 3/3/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class Website {
    
    var objectId: String!
    var name: String!
    var url: String!
    var contestStatus: String!
    
    init() {
        self.name = ""
        self.objectId = ""
        self.url = ""
        self.contestStatus = "4"
    }
    
    init(id: String , name: String , url: String , contestStatus: String ) {
        
        self.objectId = id
        self.name = name
        self.url = url
        self.contestStatus = contestStatus
        
    }
    
}