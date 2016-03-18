//
//  InitialViewController.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/13/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

var months = [ "January" , "February" , "March" , "April" , "May" , "June" , "July" , "August" , "September" , "October" , "November" , "December" ]

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func login(sender: AnyObject)
    {
        
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user, error) -> Void in
            
            if error != nil {
                RegisterViewController().displayAlert("Error" , message: "Login Failed" )
            } else {
                
                self.performSegueWithIdentifier("login1", sender: self)
                
            }
            
        }
        
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
