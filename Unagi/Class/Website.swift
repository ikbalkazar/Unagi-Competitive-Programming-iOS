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
    
    init(name: String!, withUrl url: String!, andObjectId objectId: String!) {
        self.name = name
        self.url = url
        self.objectId = objectId
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.url = aDecoder.decodeObjectForKey("url") as! String
        self.objectId = aDecoder.decodeObjectForKey("objectId") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.objectId, forKey: "objectId")
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
        websites.removeAll()
        Database.sharedInstance.sharedConnection?.readWithBlock({ (transaction) in
            let keys = transaction.allKeysInCollection(collection) as! [String]
            for key in keys {
                let website = transaction.objectForKey(key, inCollection: collection) as! Website
                websites.append(website)
            }
        })
    }
    
    static func updateWebsiteEntity(completion: (() -> ())?) {
        Request.get(serverHost, andPath: "/website/getall") { (json) in
            websites.removeAll()
            if let jsonArray = json.array {
                for i in 0 ..< jsonArray.count {
                    let object = jsonArray[i]
                    websites.append(Website(name: object["name"].stringValue, withUrl: object["url"].stringValue,
                        andObjectId: "\(object["id"].intValue)"))
                }
            }
            Database.sharedInstance.newConnection().readWriteWithBlock({ (transaction) in
                websites.saveWithTransaction(transaction)
            })
            if completion != nil {
                completion!()
            }
        }
    }
}