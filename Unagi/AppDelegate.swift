//AppDelegate.swift

import UIKit
import CoreData
import Parse

var contests = [Contest]()
var problems = [Problem]()
var websites = [Website]()
var filteredContests = [Contest]()

var userData: UserData!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var navCont: UINavigationController?
    
    func handleFirstTimeProcedures() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(true, forKey: "firstTimeCheck")
        defaults.setValue(0, forKey: "contestObjectIdCounter")
        
        preLoadWebsiteEntity()
    }
    
    func setWindow() {
        if PFUser.currentUser() != nil {
            userData.load({
                self.createMenuView()
            })
        } else {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let loginViewController = self.storyboard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
            
            self.window?.rootViewController = loginViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    func setWaitingWindow() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let loadingViewController = self.storyboard.instantiateViewControllerWithIdentifier("LoadingView") as! LoadingViewController
        
        self.window?.rootViewController = loadingViewController
        self.window?.makeKeyAndVisible()
    }

    func createMenuView() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let navigationController = self.storyboard.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
        self.navCont = navigationController
        self.window?.rootViewController = navigationController
        
        UIView.animateWithDuration(0.3) {
            self.window?.makeKeyAndVisible()
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("8xMwvCqficeHwkS7Ag5PQWdlw1q91ujGcXVRgUnG",
        clientKey: "yXQByidQA8eNkR0NaALnq2KZUvzMhQ9AvPNylyeO")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        userData = UserData()
        
        setWaitingWindow()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("firstTimeCheck") == nil {
            print("First Time Check!!")
            self.handleFirstTimeProcedures()
        }
        
        initializeWebsitesArrayUsingWebsiteEntity()
        
        updateProblemEntityUsingParse({
            self.setWindow()
        })
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: \(error)")
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        userData.save()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        userData.save()
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
        let modelURL = NSBundle.mainBundle().URLForResource("MainDatabases", withExtension: "momd")!
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

