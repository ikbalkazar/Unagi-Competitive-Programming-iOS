//
//  RightViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse

class RightViewController : UIViewController {
    
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
                PFUser.currentUser()?.saveInBackground()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cfHandle = PFUser.currentUser()?.objectForKey("codeforcesHandle")
        cfHandleSetButton.setTitle(cfHandle as? String, forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
