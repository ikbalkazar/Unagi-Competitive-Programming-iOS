//
//  ContestTableViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 18/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

var selectedContest: Contest!

class ContestTableViewController: UITableViewController {
    
    var allContests = [Contest]()
    var filteredContests = [Contest]()
    var refresher: UIRefreshControl!
    weak var delegate: LeftMenuProtocol?
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func isSource(website: String) -> Bool {
        if let outcome = NSUserDefaults.standardUserDefaults().objectForKey(website + "filtered") {
            return outcome as! Bool
        } else {
            //it means first time ever
            return false
        }
    }
    
    func downloadContests() {
        
        print("Download Started")
        
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFrom : String = dateFormatter.stringFromDate(now)
        
        let url:NSURL = NSURL(string: "https://clist.by/api/v1/json/contest/?start__gte=" + dateFrom + "&username=ikbalkazar&api_key=b66864909a08b2ddf96b258a146bd15c2db6a469&order_by=start")!
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        print("Began ignoring interaction events")
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let urlSession = NSURLSession(configuration: config)
        
        let myQuery = urlSession.dataTaskWithURL(url, completionHandler: {
            data, response, error -> Void in
            
            if let content = data {
                do {
                    let jsonRes = try NSJSONSerialization.JSONObjectWithData(content, options: NSJSONReadingOptions.MutableContainers)
                    let objects = jsonRes["objects"]!!
                    print("Json convertion is successful")
                    for var i = 0; i < objects.count; i++
                    {
                        var event = "No information on event name"
                        var start = "No information on start time"
                        var end   = "No information on end time"
                        var dur:Double = -1
                        var url   = "No information on url"
                        var website = "No information on website"
                        if let tmp = objects[i]["event"] as? String {
                            event = tmp
                        }
                        if let tmp = objects[i]["start"] as? String {
                            start = tmp
                        }
                        if let tmp = objects[i]["end"] as? String {
                            end = tmp
                        }
                        if let tmp = objects[i]["duration"] as? Double {
                            dur = tmp
                        }
                        if let tmp = objects[i]["href"] as? String {
                            url = tmp
                        }
                        if let tmp = objects[i]["resource"] {
                            if let tmp2 = tmp!["name"] as? String {
                                website = tmp2
                            }
                        }
                        
                        self.allContests.append(Contest(event: event, start: start, end: end, duration: dur, url: url, website: website))
                    }
                    
                } catch {
                    self.displayAlert("Error" , message: "Can not convert to JSON")
                }
            } else {
                self.displayAlert("Error" , message: "No new data found. Check your internet connection")
            }
            self.refresher.endRefreshing()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            print("Ended ignoring interaction events")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.updateContests()
            })
        })
        myQuery.resume()
        
        print("Download Finished")
        
    }
    
    func updateContests() {
        print("Update started")
        filteredContests.removeAll()
        for contest in allContests {
            
            if ( NSUserDefaults.standardUserDefaults().objectForKey(contest.website.name! + "filtered") as! Bool ) == true {
                filteredContests.append(contest)
            }
            
        }
        print("Update finished")
        print("Reload started")
        self.tableView.reloadData()
        print("Reload finished")
    }
    
    override func viewDidLoad() {
        
        print("View Did Load")
        
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "downloadContests", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        downloadContests()
    
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print("View Will Appear")
        
        super.viewWillAppear(animated)
        
        updateContests()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContests.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCellWithIdentifier("ContestTableCell", forIndexPath: indexPath) as! ContestTableViewCell
        
        if indexPath.row == 1 {
            print("Table is loading")
        }
        
        // Hard to explain but this is required
        // Update: Might not be required anymore but still in case
        if indexPath.row < filteredContests.count {
            cell.setContest(filteredContests[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        selectedContest = filteredContests[indexPath.row]
        performSegueWithIdentifier("Contest_Content", sender: self)
        
        return indexPath
    }

    @IBAction func goToHome(sender: AnyObject) {
        delegate?.changeViewController(LeftMenu.Main)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func goToFilterTable(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("ShowFilterTable", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
