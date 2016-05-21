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

var problemForId: [String: Problem]!
var problemForName: [String: Problem]!
var problemForUrl: [String: Problem]!

func createProblemMaps() {
    problemForId = [:]
    problemForName = [:]
    problemForUrl = [:]
    for problem in problems {
        problemForId[problem.objectId] = problem
        problemForName[problem.name] = problem
        problemForUrl[problem.url] = problem
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
        createProblemMaps()
    } catch {
        print("There is a problem getting Problems from Core Data")
    }
    
    print("Problems Array Size => \(problems.count)")
    
}

var parseProblemsCount: Int = 0
    
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
    
    var map: [String : Website] = [:]
    
    for website in websites {
        map[website.name] = website
    }
    
    query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        
        if error == nil {
            
            if let objects = objects {
                
                for problem in objects {
                    
                    let newProblem = Problem(entity: entity, insertIntoManagedObjectContext: context)
                    
                    newProblem.objectId = problem.objectId!
                    
                    newProblem.name = problem["name"] as! String
                    newProblem.url = problem["url"] as! String
                    if let tags = problem["tags"] {
                        newProblem.tags = tags as! [String]
                    }
                    newProblem.solutionUrl = problem["solutionUrl"] as? String
                    
                    if let website = map[ problem["websiteId"] as! String ] {
                        newProblem.website = website
                    } else {
                        newProblem.website = websites.last
                    }
                }
                
            } else {
                print("Problems Data Base could not updated!!! Check the internet connection - 1")
            }
            parseProblemsCount += 1
            if parseProblemsCount == 10 {
                print("seconds => \(NSDate().timeIntervalSinceDate(date))")
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "ProblemsDB_LastUpdateTime")
                initializeProblemsArrayUsingProblemEntity()
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        try context.save()
                    } catch {
                        print("Could not save to Core Data - Problem Entity")
                    }
                    
                })
                
                print("Goes to Main View Controller")
                print("#Problems = \(problems.count)")
                dispatch_async(dispatch_get_main_queue(), {
                    appDel.setWindow()
                })
            }
            
        } else {
            print("Problems Data Base could not updated!!! Check the internet connection - 2")
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
}
