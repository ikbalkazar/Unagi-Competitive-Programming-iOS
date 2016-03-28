//
//  Problem.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/28/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse

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

func initializeProblemsArrayUsingProblemEntity() {
    
    print("Get Problems from Core Data - Problem Entity")
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let request = NSFetchRequest(entityName: "Problem")
    request.returnsObjectsAsFaults = false
    do {
        let results = try context.executeFetchRequest(request) as! [NSManagedObject]
        for problem in results {
            
            let newProblem = Problem()
            
            newProblem.objectId = problem.valueForKey("objectId") as? String
            newProblem.name = problem.valueForKey("name") as? String
            newProblem.url = problem.valueForKey("url") as? String
            newProblem.tags = problem.valueForKey("tags") as! [String]
            newProblem.solutionUrl = problem.valueForKey("solutionUrl") as? String
            newProblem.website = problem.valueForKey("website") as? Website
            
            problems.append(newProblem)
            
        }
        
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

func preLoadProblemEntity() {
    
    print("preLoadProblemEntity")
    
    if let contentsOfUrl = NSBundle.mainBundle().URLForResource("Problem", withExtension: "csv") {
        
        do {
            let content = try String(contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding)
            let items = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            for item in items {
                
                let separator = "Something" // Change this line!!!
                
                let objects = item.componentsSeparatedByString(separator)
                
                let newProblem = Problem()
                
                saveToEntity("Problem", object: newProblem)
                
            }
            
            // Change this line every time making an update to Problems.csv
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "ProblemsDB_LastUpdateTime")
            
            print("Pre Loading Problem Entity done")
            
        } catch {
            
            print("Error occured parsing Problem.csv")
            
        }
        
    } else {
        print("Problem.csv does not exist")
    }
    
}

/*
 For now this function supports no more than 1000 updates on Problem Entity
 */

func updateProblemEntityUsingParse() {
    
    print("Update Problems Entity with new entries in Problem DataBase on Parse")
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let query = PFQuery(className: "Problems")
    
    query.limit = 1000
    
    if let lastUpdate = NSUserDefaults.standardUserDefaults().objectForKey("ProblemsDB_LastUpdateTime") {
        query.whereKey("updatedAt", greaterThan: lastUpdate)
    }
    
    query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        
        if error == nil {
            
            if let objects = objects {
                
                for problem in objects {
                    
                    let request = NSFetchRequest(entityName: "Problem")
                    request.returnsObjectsAsFaults = false
                    
                    request.predicate = NSPredicate(format: "objectId == %@", problem.objectId! )
                    
                    do {
                        let results = try context.executeFetchRequest(request) as! [NSManagedObject]
                        
                        if results.count < 2 {
                            
                            let newProblem = Problem()
                            
                            newProblem.objectId = problem.objectId!
                            newProblem.name = problem["name"] as! String
                            newProblem.url = problem["url"] as! String
                            newProblem.tags = problem["tags"] as! [String]
                            newProblem.solutionUrl = problem["solutionUrl"] as? String
                            newProblem.website = problem["website"] as? Website
                            
                            if results.count == 1 {
                                context.deleteObject(results[0])
                                do {
                                    try context.save()
                                } catch {
                                    print("Error saving into Core Data - Deleting Problems Database")
                                }
                            }
                            
                            saveToEntity("Problem", object: newProblem)
                            
                        }
                    } catch {
                        print("Could not execute the Fetch Request")
                    }
                    
                }
                
            }
            
            
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "ProblemsDB_LastUpdateTime")
            
        } else {
            print("Problems Data Base could not updated!!! Check the internet connection")
        }
        
        initializeProblemsArrayUsingProblemEntity()
        
    }
    
}

