//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse
import CoreData


class MainViewController: UIViewController {
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func topButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("ShowTabView", sender: self);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //Following 3 lines are temporary
        
        userDefaults.setValue( websites[0].name , forKey: "TopWebsite")
        
        userDefaults.setValue( websites[1].name , forKey: "LeftWebsite")
        
        userDefaults.setValue( websites[2].name , forKey: "RightWebsite")
        
        topButton.setBackgroundImage(UIImage(named: userDefaults.objectForKey("TopWebsite") as! String + "_Logo.png"), forState: .Normal)
        
        topButton.layer.cornerRadius = 10
        
        leftButton.setBackgroundImage(UIImage(named: userDefaults.objectForKey("LeftWebsite") as! String + "_Logo.png"), forState: .Normal)
        
        rightButton.setBackgroundImage(UIImage(named: userDefaults.objectForKey("RightWebsite") as! String + "_Logo.png"), forState: .Normal)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
