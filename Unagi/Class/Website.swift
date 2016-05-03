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

class Website: NSManagedObject {
   
    @NSManaged var objectId: String!
    @NSManaged var url: String!
    @NSManaged var name: String!
    @NSManaged var contestStatus: String!
    
    override init( entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext? ) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}


func initializeWebsitesArrayUsingWebsiteEntity() {
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let request = NSFetchRequest(entityName: "Website")
    request.returnsObjectsAsFaults = false
    do {
        let results = try context.executeFetchRequest(request) as! [Website]
        for website in results {
            websites.append( website )
        }
        
        //Moves codeforces codechef and topcoder to the top of the list
        var ptr = 0
        for toBeMoved in ["Codeforces", "Codechef", "Topcoder"] {
            for i in 0 ..< websites.count {
                if websites[i].name == toBeMoved {
                    swap(&websites[i], &websites[ptr])
                }
            }
            ptr += 1
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
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    let entity = NSEntityDescription.entityForName("Website", inManagedObjectContext: context)!
    
    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "nonefiltered")
    
    if let contentsOfUrl = NSBundle.mainBundle().URLForResource("Website", withExtension: "csv") {
        
        do {
            let content = try String(contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding)
            let items = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            for item in items {
                let objects = item.componentsSeparatedByString(",")
                let newWebsite = Website(entity: entity, insertIntoManagedObjectContext: context)
                
                newWebsite.objectId = objects[0]
                newWebsite.name = objects[1]
                newWebsite.url = objects[2]
                newWebsite.contestStatus = objects[3]
                
                dispatch_async(dispatch_get_main_queue(), { 
                    do {
                        try context.save()
                        NSUserDefaults.standardUserDefaults().setValue(true, forKey: newWebsite.name + "filtered")
                    } catch {
                        print("could not save")
                    }
                })
                
            }
            
            print("Website Entity Preloaded successfully")
            
        } catch {
            print("Error occured parsing Website.csv")
        }
        
    } else {
        print("Website.csv does not exist")
    }
    
}

