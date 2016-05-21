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
        
        /*
        
        let height: CGFloat = 40
        let width: CGFloat = 200
        
        let loadingTextView = UITextView(frame:  CGRectMake(self.view.center.x - width / 2, self.view.center.y - height / 2, width, height) )
        
        self.view.backgroundColor = UIColor.purpleColor()
        
        loadingTextView.text = "Loading ..."
        
        loadingTextView.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(loadingTextView)*/
    }
    
    override func viewDidAppear(animated: Bool) {
        EZLoadingActivity.show("Loading", disableUI: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
