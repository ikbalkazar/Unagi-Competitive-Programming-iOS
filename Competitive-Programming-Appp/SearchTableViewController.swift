//
//  SearchTableViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 27/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

//Currently downloads the problem data base. Will be changed with parse cloud code.

class SearchTableViewController: UITableViewController {

    var requestedProblems = [String]()
    
    func downloadProblems(skip: Int) {
        let query = PFQuery(className: "Problems")
        query.limit = 1000
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Problems are successfuly received")
                if let objects = objects {
                    for object in objects {
                        var matched: Bool = false
                        let problemName = object["name"] as! String
                        print("Problem Name: " + problemName)
                        if problemName.lowercaseString.rangeOfString(curSearchText_.lowercaseString) != nil {
                            matched = true
                        } else {
                            if let tags = object["tags"] as? [String] {
                                for tag in tags {
                                    print("#tag = " + tag)
                                    if tag.lowercaseString.rangeOfString(curSearchText_.lowercaseString) != nil {
                                        matched = true
                                        break
                                    }
                                }
                            }
                        }
                        if matched {
                            self.requestedProblems.append(problemName)
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            } else {
                print("Error: \(error!) \(error!.userInfo["error"])")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadProblems(0)
        downloadProblems(1000)
        downloadProblems(2000)
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
        // #warning Incomplete implementation, return the number of rows
        return requestedProblems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = requestedProblems[indexPath.row]
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
