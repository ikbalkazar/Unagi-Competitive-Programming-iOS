//
//  ContestTableViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 18/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import CoreData

var selectedContest: Contest!

class ContestTableViewController: UITableViewController {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ContestTableViewController - viewDidLoad() ")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("ContestTableViewController - viewDidAppear() ")
        
    }
    
    func refresh() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("ContestTableViewController - viewWillAppear()")
        super.viewWillAppear(animated)
        
        if contests.count == 0 {
            downloadContestsUsingClistByAPI(self)
        } else {
            updateFilteredContestsArray()
            refresh()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Removing contests and filteredContests arrays")
        contests.removeAll()
        filteredContests.removeAll()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContests.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCellWithIdentifier("ContestTableCell", forIndexPath: indexPath) as! ContestTableViewCell
        
        cell.setContestAttributes(filteredContests[indexPath.row])
        cell.delegate = self
        
        return cell
    }

    @IBAction func goToHome(sender: AnyObject) {
        print("Going Home")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func goToFilterTable(sender: AnyObject) {
        print("Going to filter Table")
        performSegueWithIdentifier("ShowFilterTable", sender: self)
    }
}
