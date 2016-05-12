//
//  Problem.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import CoreData
import Parse


class Problem: NSManagedObject {
    
    @NSManaged var name: String!
    @NSManaged var objectId: String!
    @NSManaged var url: String!
    @NSManaged var tags: NSObject?
    @NSManaged var solutionUrl: String?
    @NSManaged var website: Website!
    
    override init( entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext? ) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
}

func initializeProblemsArrayUsingProblemEntity() {
    
    print("Get Problems from Core Data - Problem Entity")
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let request = NSFetchRequest(entityName: "Problem")
    request.returnsObjectsAsFaults = false
    request.fetchBatchSize = 20
    do {
        problems = try context.executeFetchRequest(request) as! [Problem]
    } catch {
        print("There is a problem getting Problems from Core Data")
    }
    
    print("Problems Array Size => \(problems.count)")
    
}

/*
 Note: Does not work!!!
 Note: Make a decision on the csv file format
 
 Preloads websites and stores it in Core Data - Problem Entity
 */

/*
 For now this function supports no more than 1000 updates on Problem Entity
*/
var s: Int = 0
var totalTime = 0.0
    
func getNewProblemsUsingParse(limit: Int, skip: Int) {
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    let entity = NSEntityDescription.entityForName("Problem", inManagedObjectContext: context)!
    
    let query = PFQuery(className: "Problems")
    
    query.limit = limit
    query.skip = skip
    
    if let lastUpdate = NSUserDefaults.standardUserDefaults().objectForKey("ProblemsDB_LastUpdateTime") {
        query.whereKey("updatedAt", greaterThan: lastUpdate)
    }
    
    query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        
        if error == nil {
            
            if let objects = objects {
                
                print("size = \(objects.count)")
                
                for problem in objects {
                    
                    let newProblem = Problem(entity: entity, insertIntoManagedObjectContext: context)
                    
                    newProblem.objectId = problem.objectId!
                    newProblem.name = problem["name"] as! String
                    newProblem.url = problem["url"] as! String
                    if let tags = problem["tags"] {
                        newProblem.tags = tags as! [String]
                    }
                    newProblem.solutionUrl = problem["solutionUrl"] as? String
                    let websiteName = problem["websiteId"] as! String
                    newProblem.website = websites.last!
                    for website in websites {
                        if website.name == websiteName {
                            newProblem.website = website
                            break
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        do {
                            try context.save()
                        } catch {
                            print("Could not save context - Problem Entity")
                        }
                    })
                    
                }
                
            }
            s += 1
            print("s = \(s)")
            if s == 10 {
                print( "seconds => \(NSDate().timeIntervalSinceDate(date))")
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "ProblemsDB_LastUpdateTime")
                initializeProblemsArrayUsingProblemEntity()
                print("Goes to Main View Controller")
                print("#Problems = \(problems.count)")
                dispatch_async(dispatch_get_main_queue(), { 
                    appDel.setWindow()
                })
            }
            
        } else {
            print("Problems Data Base could not updated!!! Check the internet connection")
        }
    }
}

var date: NSDate!

func updateProblemEntityUsingParse() {
    
    date = NSDate()
    
    print("Update Problems Entity with new entries in Problem DataBase on Parse")
    for i in 0 ..< 10 {
        dispatch_async(dispatch_get_main_queue(), { 
            getNewProblemsUsingParse(1000, skip: i * 1000)
        })
    }
    print("Total time = \(totalTime)")
}
