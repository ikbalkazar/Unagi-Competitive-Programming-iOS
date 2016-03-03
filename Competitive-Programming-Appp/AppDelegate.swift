//
//  AppDelegate.swift
//

import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func initializeWebsitesArrayFromCoreData() {
        
        print("Get websites from Core Data")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Website")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.executeFetchRequest(request)
            for website in results as! [NSManagedObject] {
                
                let objectId = website.valueForKey("objectId") as! String
                let name = website.valueForKey("name") as! String
                let url = website.valueForKey("url") as! String
                let contestStatus = website.valueForKey("contestStatus") as! String
                websites.append( Website(id: objectId, name: name, url: url, contestStatus: contestStatus) )
                
            }
            
            print("count => \(websites.count)")
            
        } catch {
            print("There is a problem getting websites from Core Data")
        }
        
    }
    
    /*
        Downlaods the Website Database and stores it in Core Data "Website" Entity
    */
    
    func downloadWebsiteDBFromParse() {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "nonefiltered")
        
        let query = PFQuery(className: "Websites")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error != nil {
                print("Error downloading websites from Parse DB\n \(error?.userInfo["error"])")
            } else {
                if let sites = objects {
                    print("size = " + "\(sites.count)")
                    for site in sites {
                        
                        let name = site["name"] as! String
                        let id = site.objectId!
                        let url = site["url"] as! String
                        let contestStatus = "\(site["contestStatus"])"
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: name + "filtered")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let newSite = NSEntityDescription.insertNewObjectForEntityForName("Website", inManagedObjectContext: context)
                            newSite.setValue(name, forKey: "name")
                            newSite.setValue(id, forKey: "objectId")
                            newSite.setValue(url, forKey: "url")
                            newSite.setValue(contestStatus, forKey: "contestStatus")
                            do {
                                try context.save()
                            } catch {
                                print("Error saving into Core Data - Website Database")
                            }
                        })
                        
                    }
                }
            }
            
        }
        
    }
    
    
    func updateProblemsDBOnCoreData() {
        
        //Does not work as desired right now.
        
        print("Update Problems DataBase on Core Data with new entries in Problem DataBase on Parse")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let query = PFQuery(className: "Problems")
        
        //Since this is the maximum limit we should do this in a loop until there will be no result coming from "query"
        query.limit = 1000
        
        if let lastUpdateTime = NSUserDefaults.standardUserDefaults().objectForKey("ProblemsDB_LastUpdateTime") {
            query.whereKey("updatedAt", greaterThan: lastUpdateTime)
        }
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                
                if let objects = objects {
                    
                    print("size of problems => \(objects.count)")
                    
                    for problem in objects {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let newProblem = NSEntityDescription.insertNewObjectForEntityForName("Problem", inManagedObjectContext: context)
                            
                            newProblem.setValue(problem.objectId!, forKey: "objectId")
                            
                            if let name = problem["name"] as? String {
                                newProblem.setValue(name, forKey: "name")
                            }
                            
                            if let url = problem["url"] as? String {
                                newProblem.setValue(url, forKey: "url")
                            }
                            
                            if let tags = problem["tags"] as? [String] {
                                newProblem.setValue(tags, forKey: "tags")
                            }
                            
                            if let contestId = problem["contestId"] as? String {
                                newProblem.setValue(contestId, forKey: "contestId")
                            }
                            
                            if let solutionUrl = problem["solutionUrl"] as? String {
                                newProblem.setValue(solutionUrl, forKey: "solutionUrl")
                            }
                            
                            if let difficulty = problem["difficulty"] as? Int16 {
                                //    newProblem.setValue(difficulty, forKey: "difficulty")
                            }
                            
                            if let rating = problem["rating"] as? Double {
                                //    newProblem.setValue(rating, forKey: "rating")
                            }
                            
                            if let websiteId = problem["websiteId"] as? String {
                                newProblem.setValue(websiteId, forKey: "websiteId")
                            }
                            
                            newProblem.setValue(NSDate(), forKey: "updatedAt")
                            
                            do {
                                try context.save()
                            } catch {
                                print("Error saving into Core Data - Problems Database")
                            }
                            
                        })
                        
                    }
                    
                }
                
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "ProblemsDB_LastUpdateTime")
                
            } else {
                print("Problems Data Base could not updated!!! Check the internet connection")
            }
            
        }
        
    }

    
    private func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    func initializeWebsitesArray() {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if NSUserDefaults.standardUserDefaults().objectForKey("WebsiteTableDownloaded") == nil {
                self.downloadWebsiteDBFromParse()
                NSUserDefaults.standardUserDefaults().setObject(true, forKey: "WebsiteTableDownloaded")
            }
            self.initializeWebsitesArrayFromCoreData()
            
        }
    
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        print("Application 1")
        
        Parse.setApplicationId("8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
            clientKey: "yXQByidQA8eNkR0NaALnq2KZUvzMhQ9AvPNylyeO")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        print("Application 2")
        
        initializeWebsitesArray()
        
     //   updateProblemsDBOnCoreData()
        
        self.createMenuView()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "dekatotoro.test11" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Competitive_Programming_Appp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("test11.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
}

