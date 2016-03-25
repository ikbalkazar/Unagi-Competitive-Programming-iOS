//
//  ProblemTabBarController.swift
//  Unagi
//
//  Created by ikbal kazar on 24/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ProblemTabBarController: UITabBarController {
    var viaSegue_problem: Problem?
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
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
    }
}
