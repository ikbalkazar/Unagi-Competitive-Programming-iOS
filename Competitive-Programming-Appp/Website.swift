//
//  Website.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/25/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class Website {
    
    var name: String!
    var objectId: String!
    var url: String!
    var contestStatus: String!
    
    init() {
        name = ""
        objectId = ""
        url = ""
        contestStatus = "4"
    }
    
    init( name: String , id objectId: String, url: String, contestStatus: String ) {

        self.name = name
        self.objectId = objectId
        self.url = url
        self.contestStatus = contestStatus
        
    }
    
    
    
    

}
