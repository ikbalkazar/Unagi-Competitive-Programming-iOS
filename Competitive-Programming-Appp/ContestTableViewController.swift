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
    
    var contests = [Contest]()
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
    
    func loadContests() {
        
        contests.removeAll()
        self.refresher.endRefreshing()
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
                        
                        //To get rid of russian named contests
                        //Nice try bro !!!
                        
                        if self.isSource(website) {
                            let newContest = Contest(event: event, start: start, end: end, duration: dur, url: url, website: website)
                            self.contests.append(newContest)
                        }
                    }
                    
                    print("Loading is done")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                    
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    print("Ended ignoring interaction events")
                } catch {
                    self.displayAlert("Error" , message: "Can not convert to JSON")
                }
            } else {
                self.displayAlert("Error" , message: "No data Found")
            }
        })
        myQuery.resume()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "loadContests", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        loadContests()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadContests()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        return contests.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCellWithIdentifier("ContestTableCell", forIndexPath: indexPath) as! ContestTableViewCell
        
        // Hard to explain but this is required
        if indexPath.row < contests.count {
            let contest = contests[indexPath.row]
            cell.setContest(contest)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        selectedContest = contests[indexPath.row]
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
