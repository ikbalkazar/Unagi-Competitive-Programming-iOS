//
//  Website.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import YapDatabase

class Website: NSObject, NSCoding {
    var name: String!
    var url: String!
    var objectId: String!
    var contestStatus: String!
    
    init(name: String!, withUrl url: String!, andObjectId objectId: String!,
         andContestStatus contestStatus: String!) {
        self.name = name
        self.url = url
        self.objectId = objectId
        self.contestStatus = contestStatus
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.url = aDecoder.decodeObjectForKey("url") as! String
        self.objectId = aDecoder.decodeObjectForKey("objectId") as! String
        self.contestStatus = aDecoder.decodeObjectForKey("contestStatus") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.objectId, forKey: "objectId")
        aCoder.encodeObject(self.contestStatus, forKey: "contestStatus")
    }
}

extension Website {
    @nonobjc static let collection = String(Website)
    
    func key() -> String {
        return objectId
    }
    
    func saveWithTransaction(transaction: YapDatabaseReadWriteTransaction) {
        transaction.setObject(self, forKey: key(), inCollection: Website.collection)
    }
    
    static func initWebsitesArray() {
        Database.sharedInstance.sharedConnection?.readWithBlock({ (transaction) in
            let keys = transaction.allKeysInCollection(collection) as! [String]
            for key in keys {
                let website = transaction.objectForKey(key, inCollection: collection) as! Website
                websites.append(website)
            }
        })
    }
    
    static func preloadWebsites() {
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "nonefiltered")
        if let contentsOfUrl = NSBundle.mainBundle().URLForResource("Website", withExtension: "csv") {
            do {
                let content = try String(contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding)
                let items = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                
                for item in items {
                    let objects = item.componentsSeparatedByString(",")
                    let newWebsite = Website(name: objects[1], withUrl: objects[2],
                                             andObjectId: objects[0], andContestStatus: objects[3])
                    Database.sharedInstance.sharedConnection?.readWriteWithBlock({ (transaction) in
                        newWebsite.saveWithTransaction(transaction)
                    })
                }
            } catch {
                print("Error occured parsing Website.csv")
            }
        } else {
            print("Website.csv does not exist")
        }
    }
}