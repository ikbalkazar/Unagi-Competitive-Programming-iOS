//
//  ProblemTabBarController.swift
//  Unagi
//
//  Created by ikbal kazar on 24/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ProblemTabBarController: UITabBarController {
    var viaSegue_problem: Problem = Problem()
    override func viewDidLoad() {
        
    }
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("Choosen item = \(item.title)")
    }
}
