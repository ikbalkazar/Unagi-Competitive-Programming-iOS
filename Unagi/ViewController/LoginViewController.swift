//
//  InitialViewController.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/13/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse
import ZFRippleButton

class LoginViewController: UIViewController, UIApplicationDelegate, UITextFieldDelegate {
    var window: UIWindow?
    
    let usernameTextField: UITextField = UITextField()
    let passwordTextField: UITextField = UITextField()
    
    var usernameTextFieldHash: Int!
    var passwordTextFieldHash: Int!
    
    func login( sender: AnyObject ) {
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (puser, error) -> Void in
            if error != nil {
                var errorMessage = "Please try again"
                if let tmp = error!.userInfo["error"] as? String {
                    errorMessage = tmp
                }
                self.displayAlert("Error loggin in" , message: errorMessage)
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            } else {
                
                if puser != PFUser.currentUser() {
                    fatalError("There is an error with user login")
                }
                
                let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                appDel.downloadUserContent(true)// true means it will create a menu view afterwards.
            }
        }
        
    }
    
    func loginButtonDidTapped() {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            self.displayAlert("Error" , message: "Please fill out both fields")
        } else {
            self.login(self)
        }
        
    }
    
    func registerButtonDidTapped() {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topx: CGFloat = 72
        let topy: CGFloat = 340
        let height: CGFloat = 35
        let width: CGFloat = 230
        
        usernameTextField.frame = CGRectMake(topx,topy,width,height)
        usernameTextField.placeholder = "username"
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameTextField.setBottomBorder(UIColor.darkGrayColor())
        self.usernameTextFieldHash = usernameTextField.hash
        
        passwordTextField.frame = CGRectMake(topx,topy+40,width,height)
        passwordTextField.placeholder = "password"
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.secureTextEntry = true
        passwordTextField.setBottomBorder(UIColor.darkGrayColor())
        self.passwordTextFieldHash = passwordTextField.hash
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let loginButton = ZFRippleButton(type: .Custom)
        
        loginButton.frame = CGRectMake(topx, topy+130, width, height+5)
        loginButton.layer.cornerRadius = 18
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.backgroundColor = UIColor.redColor()
        loginButton.addTarget(self, action: #selector(self.loginButtonDidTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        let orText = UITextView(frame: CGRectMake(topx, topy+175, width, height))
        
        orText.text = "OR"
        orText.textAlignment = NSTextAlignment.Center
        orText.alpha = 0.7
        orText.backgroundColor = UIColor.clearColor()
        
        let registerButton  = ZFRippleButton(type: .Custom)
        
        registerButton.frame = CGRectMake(topx, topy+210, width, height+5)
        registerButton.layer.cornerRadius = 18
        registerButton.setTitle("REGISTER" , forState:  .Normal)
        registerButton.backgroundColor = UIColor.redColor()
        registerButton.addTarget(self, action: #selector(self.registerButtonDidTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(orText)
        view.addSubview(registerButton)
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
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
