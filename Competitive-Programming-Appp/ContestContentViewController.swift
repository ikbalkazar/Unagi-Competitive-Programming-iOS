//
//  ContestContentViewController.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/14/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ContestContentViewController: UIViewController {

    @IBOutlet weak var contestSiteLabel: UILabel!
    @IBOutlet weak var contestNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBAction func dismissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goContestWebsite(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: selectedContest.url)!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contestSiteLabel.text = selectedContest.event
        contestNameLabel.text = selectedContest.event
        startTimeLabel.text = selectedContest.startTime
        endTimeLabel.text = selectedContest.endTime
        durationLabel.text = selectedContest.duration
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
