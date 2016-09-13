//
//  WebsiteImporter.swift
//  Unagi
//
//  Created by ikbal kazar on 12/09/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class WebsiteImporter {
    static let dbConnection = Database.sharedInstance.newConnection();
    
    class func importSolved(websiteName: String, andSolvedIds solvedIds: [String]) {
        var solvedMap: [String: Bool] = [:]
        for id in solvedIds {
            solvedMap[id] = true
        }
        dbConnection.readWriteWithBlock { (transaction) in
            for problem in problems {
                if problem.website.name == websiteName {
                    problem.isSolved = solvedMap[problem.objectId] != nil ? solvedMap[problem.objectId]! : false
                    problem.saveWithTransaction(transaction)
                }
            }
        }
    }
}
