//AppDelegate.swift


import UIKit
import CoreData
import Parse
import Async

var contests = [Contest]()
var problems = [Problem]()
var websites = [Website]()
var filteredContests = [Contest]()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
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
    
    func initializeProblemsArrayUsingProblemEntity() {
        
        print("Get Problems from Core Data - Problem Entity")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Problem")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.executeFetchRequest(request)
            for problem in results as! [NSManagedObject] {
                
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
     Note: Make a decision on the input format
     
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
        
        var s1 = 0
        var s2 = 0
        
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
                            if results.count > 1 {
                                print("We have a big problem here!!! There are objects with same objectIds")
                                return
                            } else {
                                
                                let newProblem = Problem()
                                
                                newProblem.objectId = problem.objectId
                                newProblem.name = problem["name"] as? String
                                newProblem.url = problem["url"] as? String
                                newProblem.tags = problem["tags"] as! [String]
                                newProblem.solutionUrl = problem["solutionUrl"] as? String
                                newProblem.website = problem["website"] as? Website
                                
                                if results.count == 0 {
                                    
                                    if s1%100 == 0 {
                                        print("new Entry \(s1)")
                                    }
                                    s1 += 1
                                    
                                    saveToEntity("Problem", object: newProblem)
                                    
                                    
                                } else {
                                    
                                    if s2%100 == 0 {
                                        print("Updated Entry \(s2)")
                                    }
                                    s2 += 1
                                    results[0].setValue(newProblem.objectId!, forKey: "objectId")
                                    results[0].setValue(newProblem.name, forKey: "name")
                                    results[0].setValue(newProblem.url, forKey: "url")
                                    results[0].setValue(newProblem.tags, forKey: "tags")
                                    results[0].setValue(newProblem.solutionUrl, forKey: "solutionUrl")
                                    results[0].setValue(newProblem.website, forKey: "websiteId")
                                    
                                    do {
                                        try context.save()
                                    } catch {
                                        print("Error saving into Core Data - Updating Problems Database")
                                    }
                                    
                                }
                                
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
            
            self.initializeProblemsArrayUsingProblemEntity()
            
        }
        
    }
    
    func updateFilteredContestsArray() {
        
        filteredContests.removeAll()
        
        for contest in contests {
            
            if contest.website.name == nil {
                print("FUCKED UP")
            }
            
            if NSUserDefaults.standardUserDefaults().objectForKey(contest.website.name + "filtered") as! Bool {
                filteredContests.append(contest)
            }
        }
        
    }
    
    func initializeContestsArrayUsingContestEntity() {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Contest")
        
        do {
            if let objects = try context.executeFetchRequest(request) as? [NSManagedObject] {
                
                for object in objects {
                    
                    let newContest = Contest()
                    
                    if let name = object.valueForKey("name") as? String {
                        newContest.name = name
                    }
                    if let start = object.valueForKey("start") as? String {
                        newContest.start = start
                    }
                    if let end = object.valueForKey("end") as? String {
                        newContest.end = end
                    }
                    if let dur = object.valueForKey("duration") as? Double {
                        newContest.duration = dur
                    }
                    if let url = object.valueForKey("url") as? String {
                        newContest.url = url
                    }
                    if let website = object.valueForKey("website") as? Website {
                        newContest.website = website
                    }
                    
                    contests.append(newContest)
                    
                }
                
                self.updateFilteredContestsArray()
                
            }
        } catch {
            print("Could not execute Fetch Request - Contest Entity")
        }
        
        print("Contests Array size => \(contests.count)")
        
    }
    
    func updateContestEntityUsingClistBy() {
        
        print("Contest Download Started")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFrom : String = dateFormatter.stringFromDate(now)
        
        let url:NSURL = NSURL(string: "https://clist.by/api/v1/json/contest/?start__gte=" + dateFrom + "&username=ikbalkazar&api_key=b66864909a08b2ddf96b258a146bd15c2db6a469&order_by=start")!
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let urlSession = NSURLSession(configuration: config)
        
        let myQuery = urlSession.dataTaskWithURL(url, completionHandler: {
            data, response, error -> Void in
            
            if let content = data {
                do {
                    let jsonRes = try NSJSONSerialization.JSONObjectWithData(content, options: NSJSONReadingOptions.MutableContainers)
                    let objects = jsonRes["objects"]!
                    
                    print("Json convertion is successful")
                    
                    //Delete all content first
                    let request = NSFetchRequest(entityName: "Contest")
                    do {
                        
                        if let objects = try context.executeFetchRequest(request) as? [NSManagedObject] {
                            
                            for object in objects {
                                context.deleteObject(object)
                            }
                            
                            do {
                                try context.save()
                            } catch {
                                print("Could not save")
                            }
                            
                        }
                        
                    } catch {
                        print("Could not delete objects in Contest Entity")
                    }
                    
                    for i in 0 ..< objects!.count {

                        let newContest = Contest()
                        
                        newContest.name = objects[i]?["event"] as? String
                        
                        if let tmp = objects[i]?["start"] as? String {
                            newContest.start = tmp
                        }
                        if let tmp = objects[i]?["end"] as? String {
                            newContest.end = tmp
                        }
                        if let tmp = objects[i]?["duration"] as? Double {
                            newContest.duration = tmp
                        }
                        if let tmp = objects[i]?["href"] as? String {
                            newContest.url = tmp
                        }
                         
                         if let tmp = objects[i]?["resource"] {
                            if let tmp2 = tmp?["name"] as? String {
                         
                                for site in websites {
                                    if site.name.containsString(tmp2) {
                                        newContest.website = site
                                        break
                                    }
                                }
                            }
                         }
                        
                        newContest.objectId = "\(i)"
                        
                        print( saveToEntity("Contest", object: newContest) )
                        
                    }
                    
                } catch {
                    print("Can not convert to JSON")
                }
            } else {
                print("No new data found. Check your internet connection")
            }
            
            self.initializeContestsArrayUsingContestEntity()
            print("Contest download Finished")
            
        })
        myQuery.resume()
        
    }
    
    private func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "078ac9") // used to be 689F38
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        //self.window?.makeKeyAndVisible()
    }
    
    func handleFirstTimeProcedures() {
        //is there a need for calling 'defaults.syncronize()' here????
        NSUserDefaults.standardUserDefaults().setValue(true, forKey: "firstTimeCheck")
        self.preLoadWebsiteEntity()
        self.preLoadProblemEntity()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
        clientKey: "yXQByidQA8eNkR0NaALnq2KZUvzMhQ9AvPNylyeO")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        if NSUserDefaults.standardUserDefaults().objectForKey("firstTimeCheck") == nil {
            self.handleFirstTimeProcedures()
        }
        
        self.initializeWebsitesArrayUsingWebsiteEntity()
     //   self.updateContestEntityUsingClistBy()
        self.updateProblemEntityUsingParse()
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

