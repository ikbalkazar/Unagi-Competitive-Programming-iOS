//
//  ProblemTabBarController.swift
//  Unagi
//
//  Created by ikbal kazar on 24/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ProblemTabBarController: UITabBarController {
    
    //problem to initialize tab bar views with
    var viaSegue_problem: Problem?
    var parentVC: UIViewController?
    
    override func viewDidLoad() {
        //Initializes all of the view controllers
        //Read
        let webViewController = viewControllers![0] as! ProblemStatementVC
        webViewController.setProblem(viaSegue_problem!)
        
        addRightBarItem()
   
        //Note
        let noteViewController = viewControllers![1] as! NoteTakingVC
        noteViewController.setProblem(viaSegue_problem!)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        //navigationController?.navigationBarHidden = false
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "Note" {
            } else {
            removeNavigationBarItem()
        }
        switch item.title! {
        case "Note":
            let navBarItem = UIBarButtonItem(title: "Done",
                                             style: UIBarButtonItemStyle.Done,
                                             target: self,
                                             action: #selector(self.callDoneButton))
            navigationItem.rightBarButtonItem = navBarItem
        case "Read":
            if !((viaSegue_problem?.isTodo)!) {
                addRightBarItem()
            }
        default: break
        }
    }
    
    func addRightBarItem() {
        let navBarItem = UIBarButtonItem(title: "Add to Todo List",
                                         style: .Done,
                                         target: self,
                                         action: #selector(self.addTodoButton))
        navigationItem.rightBarButtonItem = navBarItem
    }
    
    func callDoneButton() {
        let noteVC = viewControllers![1] as! NoteTakingVC
        noteVC.doneButton()
    }
    
    func addTodoButton() {
        Database.sharedInstance.sharedConnection?.readWriteWithBlock({ (transaction) in
            self.viaSegue_problem?.isTodo = true
            self.viaSegue_problem?.saveWithTransaction(transaction)
        })
        let alert = UIAlertController(title: "Successful", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
