//
//  InitialViewController.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/13/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

var user = PFUser?()

class LoginViewController: UIViewController, UIApplicationDelegate {
    var window: UIWindow?

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        print("I am here")
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (puser, error) -> Void in
            if error != nil {
                print("Error logging in")
            } else {
                self.createMenuView()
                user = puser
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
        
        /*
        
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("login1", sender: self)
        }
        
        */
        
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
