//
//  SettingsViewController.swift
//  Unagi
//
//  Created by ikbal kazar on 15/05/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var cfHandleSetButton: UIButton!
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func codeforcesHandleButtonTouched(sender: AnyObject) {
        let alertController = UIAlertController(title: "Codeforces Handle", message: "Please Enter", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Set", style: UIAlertActionStyle.Default, handler: { (action) in
            let handleTextField = alertController.textFields![0]
            if let handle = handleTextField.text {
                let button = sender as! UIButton
                button.setTitle(handle, forState: UIControlState.Normal)
                PFUser.currentUser()?.setObject(handle, forKey: "codeforcesHandle")
                
                let solved = PFUser.currentUser()?.objectForKey("solved") as! [String]
                var newSolved: [String] = []
                for id in solved {
                    if problemForId[id]!.website.name != "Codeforces" {
                        newSolved.append(id)
                    }
                }
                
                PFUser.currentUser()?.setObject(newSolved, forKey: "solved")
                
                PFUser.currentUser()?.saveInBackground()
                
                self.refreshUserData()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showErrorAlert("Empty handle is not allowed");
                })
            }
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Codeforces Handle"
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBOutlet weak var ccHandleSetButton: UIButton!
    
    @IBAction func codechefHandleButtonTouched(sender: AnyObject) {
        let alertController = UIAlertController(title: "Codechef Handle", message: "Please Enter", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Set", style: UIAlertActionStyle.Default, handler: { (action) in
            let handleTextField = alertController.textFields![0]
            if let handle = handleTextField.text {
                let button = sender as! UIButton
                button.setTitle(handle, forState: UIControlState.Normal)
                PFUser.currentUser()?.setObject(handle, forKey: "codechefHandle")
                
                let solved = PFUser.currentUser()?.objectForKey("solved") as! [String]
                var newSolved: [String] = []
                for id in solved {
                    if problemForId[id]!.website.name != "Codechef" {
                        newSolved.append(id)
                    }
                }
                
                PFUser.currentUser()?.setObject(newSolved, forKey: "solved")
                
                PFUser.currentUser()?.saveInBackground()
                
                self.refreshUserData()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showErrorAlert("Empty handle is not allowed");
                })
            }
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Codechef Handle"
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func RefreshCodeforces(sender: AnyObject) {
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            if error == nil {
                let codeforcesId = user?.objectForKey("codeforcesHandle") as! String
                PFCloud.callFunctionInBackground("codeforcesGetSolved", withParameters: ["codeforcesId": codeforcesId], block: { (data, error) in
                    var allSolved = PFUser.currentUser()?.objectForKey("solved") as! [String]
                    var solvedMap: [String: Bool] = [:]
                    for x in allSolved {
                        solvedMap[x] = true
                    }
                    
                    if let cfSolved = data as? [String] {
                        for i in 0 ..< cfSolved.count {
                            if problemForName[cfSolved[i]] != nil {
                                let id = problemForName[cfSolved[i]]!.objectId
                                if solvedMap[id] == nil {
                                    allSolved.append(id);
                                }
                            }
                        }
                        
                        PFUser.currentUser()?.setObject(allSolved, forKey: "solved")
                        PFUser.currentUser()?.saveInBackground()

                        self.refreshUserData()
                    }
                })
            }
        })
    }
    
    @IBAction func RefreshCodechef(sender: AnyObject) {
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            if error == nil {
                let codechefId = user?.objectForKey("codechefHandle") as! String
                PFCloud.callFunctionInBackground("codechefGetSolved", withParameters: ["codechefId": codechefId], block: { (data, error) in
                    var allSolved = PFUser.currentUser()?.objectForKey("solved") as! [String]
                    var solvedMap: [String: Bool] = [:]
                    for x in allSolved {
                        solvedMap[x] = true
                    }
                    
                    if let ccSolved = data as? [String] {
                        for i in 0 ..< ccSolved.count {
                            let url = "https://www.codechef.com/problems/" + ccSolved[i]
                            if problemForUrl[url] != nil {
                                let id = problemForUrl[url]!.objectId
                                if solvedMap[id] == nil {
                                    allSolved.append(id);
                                }
                            }
                        }
                        
                        PFUser.currentUser()?.setObject(allSolved, forKey: "solved")
                        PFUser.currentUser()?.saveInBackground()

                        self.refreshUserData()
                    }
                })
            }
        })
    }
    
    func refreshUserData() {
        let installation = PFInstallation.currentInstallation()
        installation.channels = []
        installation.saveInBackground()
        
        userData.load({})
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
        
        let cfHandle = PFUser.currentUser()?.objectForKey("codeforcesHandle") as? String
        cfHandleSetButton.setTitle(cfHandle, forState: UIControlState.Normal)
        
        let ccHandle = PFUser.currentUser()?.objectForKey("codechefHandle") as? String
        ccHandleSetButton.setTitle(ccHandle, forState: UIControlState.Normal)
    
        let installation = PFInstallation.currentInstallation()
        var channels = installation.objectForKey("channels") as? [String]
        if channels == nil {
            channels = []
        }
        
        print(fixed(cfHandle!))
        
        systemTestButton.setOn(channels!.contains(fixed(cfHandle!) + "SystemTest"), animated: true)
        ratingButton.setOn(channels!.contains(fixed(cfHandle!) + "Rating"), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
