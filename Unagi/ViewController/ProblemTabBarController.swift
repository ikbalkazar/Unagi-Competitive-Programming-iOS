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
   
        //Note
        let noteViewController = viewControllers![1] as! NoteTakingVC
        noteViewController.setProblem(viaSegue_problem!)
        
        //LeaderBoard
        //Similar
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
            let navBarItem = UIBarButtonItem(title: "Add",
                                             style: .Done,
                                            target: self,
                                            action: #selector(self.addTodoButton))
            navigationItem.rightBarButtonItem = navBarItem
        default: break
        }
    }
    
    func callDoneButton() {
        let noteVC = viewControllers![1] as! NoteTakingVC
        noteVC.doneButton()
    }
    
    func addTodoButton() {
        userData.add(viaSegue_problem!, key: kTodoProblemsKey)
    }
}
