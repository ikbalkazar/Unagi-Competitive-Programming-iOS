//
//  ContestTableViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 18/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ContestTableViewController: UITableViewController {

    var contests = [Contest]()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func loadContests() {
        let url:NSURL = NSURL(string: "https://clist.by/api/v1/json/contest/?username=ikbalkazar&api_key=b66864909a08b2ddf96b258a146bd15c2db6a469")!
        
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
                        var dur   = "No information on duration"
                        var url   = "No information on url"
                        if let tmp = objects[i]["event"] as? String {
                            event = tmp
                        }
                        if let tmp = objects[i]["start"] as? String {
                            start = tmp
                        }
                        if let tmp = objects[i]["end"] as? String {
                            end = tmp
                        }
                        if let tmp = objects[i]["duration"] as? String {
                            dur = tmp
                        }
                        if let tmp = objects[i]["href"] as? String {
                            url = tmp
                        }
                        
                        let newContest = Contest(event: event, start: start, end: end, duration: dur, url: url)
                        
                        self.contests.append(newContest)
                    }
                    
                    print("Loading is done")
                    
                    self.tableView.reloadData()
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

        loadContests()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        print("row count")
        return contests.count
    }
    
    
    func colorForContest(website: String ) -> UIColor {
        
        // Label contests by their names and return appropriate color
        
        switch(website)
        {
        case "Codeforces": return UIColor.blueColor()
        case "Codechef"  : return UIColor.brownColor()
        case "Topcoder"  : return UIColor.redColor()
        case "Hackerrank": return UIColor.greenColor()
        case "ACM" :       return UIColor.yellowColor()
        case "IOI" :       return UIColor.purpleColor()
        default:           return UIColor.grayColor()
        }
    }
    
    func imageForContest(website: String) -> UIImage {
        switch (website) {
        case "Codeforces":  return UIImage(named: "codeforcesLogo.png")!
        case "Codechef":    return UIImage(named: "codechefLogo.jpeg")!
        case "Topcoder":    return UIImage(named: "topcoderLogo.png")!
        case "Hackerrank":  return UIImage(named: "hackerrankLogo.png")!
        case "ACM":         return UIImage(named: "acmicpcLogo.png")!
        case "IOI":         return UIImage(named: "ioiLogo.png")!
        default:            return UIImage(named: "codeforcesLogo.png")!//Update it once app's logo is available
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ContestTableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContestTableViewCell
        
        let contest = contests[indexPath.row]
        
        cell.cellImage.image = imageForContest(contest.website)
        cell.button.setTitle(contest.event, forState: UIControlState.Normal)
        cell.contestWebsite = contest.website
        
        return cell
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
