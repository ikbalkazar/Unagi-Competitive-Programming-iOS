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
        self.contestStatus = ""
    }
    
    init(id: String , name: String , url: String , contestStatus: String ) {
        
        self.objectId = id
        self.name = name
        self.url = url
        self.contestStatus = contestStatus
        
    }
}


func initializeWebsitesArrayUsingWebsiteEntity() {
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let request = NSFetchRequest(entityName: "Website")
    request.returnsObjectsAsFaults = false
    do {
        let results = try context.executeFetchRequest(request) as! [NSManagedObject]
        for website in results {
            websites.append( Website(id: website.valueForKey("objectId") as! String, name: website.valueForKey("name") as! String, url: website.valueForKey("url") as! String, contestStatus: website.valueForKey("contestStatus") as! String) )
        }
        
    } catch {
        print("There is a problem getting websites from Core Data")
    }
    
    print("Websites Array Size = \(websites.count)")
}

/*
 Preloads websites from Website.csv and stores it in Core Data - Website Entity
 */
func preLoadWebsiteEntity() {
    
    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "nonefiltered")
    
    if let contentsOfUrl = NSBundle.mainBundle().URLForResource("Website", withExtension: "csv") {
        
        do {
            let content = try String(contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding)
            let items = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            for item in items {
                let objects = item.componentsSeparatedByString(",")
                let newWebsite = Website(id: objects[0], name: objects[1], url: objects[2], contestStatus: objects[3])
                if saveToEntity("Website", object: newWebsite) {
                    NSUserDefaults.standardUserDefaults().setObject(true, forKey: objects[1] + "filtered")
                }
            }
            
            print("Website Entity Preloaded successfully")
            
        } catch {
            print("Error occured parsing Website.csv")
        }
        
    } else {
        print("Website.csv does not exist")
    }
    
}