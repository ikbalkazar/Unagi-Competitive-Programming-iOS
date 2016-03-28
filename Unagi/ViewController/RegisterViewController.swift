//
//  RegisterViewController.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/13/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    func initAnimation(style: UIActivityIndicatorViewStyle)
    {
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.activityIndicatorViewStyle = style
        view.addSubview(activityIndicator)
    }
    
    func startAnimating() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func register(sender: AnyObject)
    {
        if username.text == "" || email.text == "" || password1.text == "" || password2.text == "" { 
            displayAlert("Error", message: "Please fill out all form elements")
            return
        }
        
        if  password1.text != password2.text {
            displayAlert("Error", message: "Passwords do not match!!!")
            return
        }
        
        let user = PFUser()
        
        user.username = username.text
        user.password = password1.text
        user.email = email.text
        
        var errorMessage = "Error"
        
        initAnimation(UIActivityIndicatorViewStyle.Gray)
        
        startAnimating()
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            
            self.stopAnimating()
            
            if error != nil {
                
                if let errorString = error!.userInfo["error"] as? String {
                    errorMessage = errorString
                }
                self.displayAlert("Error", message: errorMessage )
                return
            }
            else {
                
                self.displayAlert("Successfull", message: "Successfully Registered")
                
                self.performSegueWithIdentifier("login2", sender: self)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
