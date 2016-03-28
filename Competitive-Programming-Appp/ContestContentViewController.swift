//
//  ContestContentViewController.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/14/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ContestContentViewController: UIViewController {
    
    
    @IBOutlet weak var contestNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBAction func goContestWebsite(sender: AnyObject) {
        
        // Implement web view later
        UIApplication.sharedApplication().openURL(NSURL(string: selectedContest.url)!)
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "X_Logo.jpg")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        contestNameLabel.text = selectedContest.name
        startTimeLabel.text = selectedContest.localStart()
        endTimeLabel.text = selectedContest.localEnd()
        durationLabel.text = selectedContest.getHourMinuteDuration()
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
