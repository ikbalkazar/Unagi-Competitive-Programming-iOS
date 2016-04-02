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
    do {
        let results = try context.executeFetchRequest(request) as! [Problem]
        
        for problem in results {
            problems.append(problem)
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
    
    /*
    print("preLoadProblemEntity")
    
    if let contentsOfUrl = NSBundle.mainBundle().URLForResource("Problem", withExtension: "csv") {
        
        do {
            
            let content = try String(contentsOfURL: contentsOfUrl, encoding: NSUTF8StringEncoding)
            let items = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            for item in items {
                
                let separator = "Something" // Change this line!!!
                
                let objects = item.componentsSeparatedByString(separator)
                
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
    */
}

/*
 For now this function supports no more than 1000 updates on Problem Entity
 */

func updateProblemEntityUsingParse() {
    
    print("Update Problems Entity with new entries in Problem DataBase on Parse")
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    let entity = NSEntityDescription.entityForName("Problem", inManagedObjectContext: context)!
    
    
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
                            
                            let newProblem = Problem(entity: entity, insertIntoManagedObjectContext: context)
                            
                            newProblem.objectId = problem.objectId!
                            newProblem.name = problem["name"] as! String
                            newProblem.url = problem["url"] as! String
                            newProblem.tags = problem["tags"] as! [String]
                            newProblem.solutionUrl = problem["solutionUrl"] as? String
                            let websiteName = problem["websiteId"] as! String
                            for website in websites {
                                if website.name == websiteName {
                                    newProblem.website = website
                                    break
                                }
                            }
                            
                            if results.count == 1 {
                                context.deleteObject(results[0])
                                do {
                                    try context.save()
                                } catch {
                                    print("Error saving into Core Data - Deleting an object from Problems Database")
                                }
                            }
                            
                            do {
                               try context.save()
                            } catch {
                                print("olmadi be!!!")
                            }
                            
                            
                        } else {
                            print("More than 1 results")
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
