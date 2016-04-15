//
//  InitialViewController.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/13/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

var solvedProblems = [Problem]()
var toDoListProblems = [Problem]()

class LoginViewController: UIViewController, UIApplicationDelegate {
    var window: UIWindow?

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func deletePreviousUserContent() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.removeObjectForKey("solvedProblems")
        defaults.removeObjectForKey("toDoList")
        defaults.removeObjectForKey("profileImage")
        defaults.removeObjectForKey("username")
        
    }
    
    func downloadUserContent( ) {
        var problemMap: [String: Problem] = [:]
        for problem in problems {
            problemMap[problem.objectId] = problem
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            
            if error != nil {
                print("Could not download user content")
                return
            }
            
            self.deletePreviousUserContent()
            
            if let solvedIds = user?.objectForKey("solved") as? [String] {
                for id in solvedIds {
                    solvedProblems.append(problemMap[id]!)
                }
            }
            
            if let todoIds = user?.objectForKey("toDo") as? [String] {
                for id in todoIds {
                    toDoListProblems.append(problemMap[id]!)
                }
            }
            
            defaults.setObject(solvedProblems, forKey: "solvedProblems")
            defaults.setObject(toDoListProblems, forKey: "toDoListProblems")
            
            var profileImage = UIImage()
            
            if let userImage = user?.valueForKey("profileImage") as? PFFile {
                userImage.getDataInBackgroundWithBlock({ (data, error) in
                    if error == nil {
                        profileImage = UIImage(data: data!)!
                    } else {
                        print("Error getting image data")
                    }
                })
            }
            
            defaults.setObject(profileImage, forKey: "profileImage")
            
            var username = "error"
            if let tmp = user?.objectForKey("username") as? String {
                username = tmp
            }
            
            defaults.setObject( username , forKey: "username" )
            
            problemMap.removeAll()
        })
    }
    
    @IBAction func login(sender: AnyObject) {
        
        
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (puser, error) -> Void in
            if error != nil {
                print("Error logging in")
            } else {
                
                if puser != PFUser.currentUser() {
                    fatalError("There is an error with user login")
                }
                
                self.downloadUserContent()
                self.createMenuView()
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
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "078ac9") // used to be 689F38
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        
        let curwindow = UIApplication.sharedApplication().keyWindow
        curwindow?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        curwindow?.rootViewController = slideMenuController
        curwindow?.makeKeyAndVisible()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("LoginViewController - viewDidAppear")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
