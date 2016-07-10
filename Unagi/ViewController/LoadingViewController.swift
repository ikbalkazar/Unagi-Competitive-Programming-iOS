//
//  LoadingViewController.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/20/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import EZLoadingActivity

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        EZLoadingActivity.show("Loading", disableUI: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
