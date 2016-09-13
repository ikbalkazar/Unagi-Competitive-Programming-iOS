//
//  SettingsViewController.swift
//  Unagi
//
//  Created by ikbal kazar on 15/05/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UITableViewController {

    @IBOutlet weak var cfHandleSetButton: UIButton!
    var spinnerView: UIActivityIndicatorView?
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // UIButton that changes the codeforces handle of the user.
    @IBAction func codeforcesHandleButtonTouched(sender: AnyObject) {
        let alertController = UIAlertController(title: "Codeforces Handle", message: "Please Enter", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Set", style: UIAlertActionStyle.Default, handler: { (action) in
            dispatch_async(dispatch_get_main_queue(), {
                let handleTextField = alertController.textFields![0]
                if let handle = handleTextField.text {
                    let button = sender as! UIButton
                    button.setTitle(handle, forState: UIControlState.Normal)
                    NSUserDefaults.standardUserDefaults().setObject(handle, forKey: kCodeforcesUsernameKey)
                } else {
                    self.showErrorAlert("Empty handle is not allowed");
                }
            })
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Codeforces Handle"
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBOutlet weak var ccHandleSetButton: UIButton!
    
    // UIButton that changes codechef handle of the user.
    @IBAction func codechefHandleButtonTouched(sender: AnyObject) {
        let alertController = UIAlertController(title: "Codechef Handle", message: "Please Enter", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Set", style: UIAlertActionStyle.Default, handler: { (action) in
            dispatch_async(dispatch_get_main_queue(), { 
                let handleTextField = alertController.textFields![0]
                if let handle = handleTextField.text {
                    let button = sender as! UIButton
                    button.setTitle(handle, forState: UIControlState.Normal)
                } else {
                    self.showErrorAlert("Empty handle is not allowed");
                }
            })
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Codechef Handle"
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Gets solved problems of the user from codeforces api.
    
    @IBAction func RefreshCodeforces(sender: AnyObject) {
        spinnerView?.startAnimating()
        SolvedGetter.getCodeforces { (problemIds) in
            WebsiteImporter.importSolved("Codeforces", andSolvedIds: problemIds)
            self.spinnerView?.stopAnimating()
        }
    }
    
    // Gets solved problems of the user from codeforces api.
    
    @IBAction func RefreshCodechef(sender: AnyObject) {
    }
    
    // Remove saved channels and load user data. 
    
    func refreshUserData() {
        let installation = PFInstallation.currentInstallation()
        installation.channels = []
        installation.saveInBackground()
    }
    
    @IBAction func notifySystemTestSwitch(sender: AnyObject) {
        let switchButton = sender as! UISwitch
        var cfHandle = PFUser.currentUser()?.objectForKey("codeforcesHandle") as? String
        if cfHandle == nil {
            cfHandle = ""
        }
        let systemTestChannel = cfHandle! + "SystemTest"
        if switchButton.on {
            addChannel(systemTestChannel)
        } else {
            removeChannel(systemTestChannel)
        }
    }
    
    @IBAction func notifyRating(sender: AnyObject) {
        let switchButton = sender as! UISwitch
        var cfHandle = PFUser.currentUser()?.objectForKey("codeforcesHandle") as? String
        if cfHandle == nil {
            cfHandle = ""
        }
        let ratingChannel = cfHandle! + "Rating"
        if switchButton.on {
            addChannel(ratingChannel)
        } else {
            removeChannel(ratingChannel)
        }
    }
    
    @IBOutlet weak var systemTestButton: UISwitch!
    @IBOutlet weak var ratingButton: UISwitch!
    
    private func addChannel(channel: String) {
        let installation = PFInstallation.currentInstallation()
        installation.addUniqueObject(fixed(channel), forKey: "channels")
        installation.saveInBackground()
    }
    
    private func removeChannel(channel: String) {
        let installation = PFInstallation.currentInstallation()
        installation.removeObject(fixed(channel), forKey: "channels")
        installation.saveInBackground()
    }
    
    // Parse does not let channels to contain.
    
    func fixed(str: String) -> String {
        var res = ""
        for char in str.characters {
            if !(char >= "a" && char <= "z") && !(char >= "A" && char <= "Z") {
                res += "NONALPHASTART"
            }
            break
        }
        for char in str.characters {
            if char == "." {
                res += "DOT"
            } else {
                res += String(char)
            }
        }
        return res
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cfHandle = NSUserDefaults.standardUserDefaults().objectForKey(kCodeforcesUsernameKey) as? String
        if cfHandle == nil {
            cfHandle = "tap to set"
        }
        cfHandleSetButton.setTitle(cfHandle, forState: UIControlState.Normal)
        
        let installation = PFInstallation.currentInstallation()
        var channels = installation.objectForKey("channels") as? [String]
        if channels == nil {
            channels = []
        }
        
        systemTestButton.setOn(channels!.contains(fixed(cfHandle!) + "SystemTest"), animated: true)
        ratingButton.setOn(channels!.contains(fixed(cfHandle!) + "Rating"), animated: true)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        spinnerView = UIActivityIndicatorView(frame: CGRectMake(screenSize.width / 2 - 10,
                                                                screenSize.height / 2 - 10,
                                                                20,
                                                                20))
        spinnerView?.color = UIColor.blackColor()
        spinnerView?.hidesWhenStopped = true
        view.addSubview(spinnerView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
