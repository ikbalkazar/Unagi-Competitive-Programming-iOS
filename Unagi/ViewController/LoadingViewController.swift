//
//  LoadingViewController.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/20/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height: CGFloat = 40
        let width: CGFloat = 200
        
        let loadingTextView = UITextView(frame:  CGRectMake(self.view.bounds.width / 2 - width / 2, self.view.bounds.height - height / 2, width, height) )
        
        loadingTextView.text = "Loading ..."
        
        loadingTextView.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(loadingTextView)
        
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
