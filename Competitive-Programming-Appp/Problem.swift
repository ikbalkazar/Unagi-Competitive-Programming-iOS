//
//  Problem.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/28/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation

class Problem {
    
    var objectId: String!
    var name: String!
    var url: String!
    var tags = [String]()
    var solutionUrl: String!
    var website: Website!
    
    init() {
        objectId = ""
        name = ""
        url = ""
        tags = [String]()
        solutionUrl = ""
        website = noneWebsite
    }
    
    init( objectId: String, name: String, url: String, tags: [String], solutionUrl: String, website: Website ){
        
        self.objectId = objectId
        self.name = name
        self.url = url
        self.tags = tags
        self.solutionUrl = solutionUrl
        self.website = website
        
    }
    
}
