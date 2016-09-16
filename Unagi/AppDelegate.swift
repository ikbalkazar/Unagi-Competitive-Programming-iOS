//AppDelegate.swift

import UIKit
import CoreData
import Parse
import SCLAlertView

var contests = [Contest]()
var problems = [Problem]()
var websites = [Website]()
var filteredContests = [Contest]()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var navCont: UINavigationController?
    
    func setWindow() {
        if PFUser.currentUser() != nil {
            createMenuView()
        } else {
            let user = PFUser()
            let installationId = Int(arc4random_uniform(UInt32(1e9)))
            user.username = String(installationId)
            user.password = String(installationId)
            user.signUpInBackgroundWithBlock({ (succeeded, error) in
                if error != nil {
                    let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                    alert.addButton("Retry", action: { 
                        self.setWindow()
                    })
                    alert.showError("No Internet Connection", subTitle: "Please make sure you are connected to internet")
                } else {
                    assert(PFUser.currentUser() != nil)
                    self.setWindow()
                }
            })
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
        
        setWaitingWindow()
        
        Website.initWebsitesArray()
        Website.updateWebsiteEntity {
            Problem.updateProblemEntity {
                dispatch_async(dispatch_get_main_queue(), {
                    self.setWindow()
                })
            }
        }
        
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
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        Problem.updateProblemEntity({})
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

