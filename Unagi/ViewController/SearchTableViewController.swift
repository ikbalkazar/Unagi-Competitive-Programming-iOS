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

var allProblems = [Problem]()

class SearchTableViewController: UITableViewController {

    var curSearchText : String?
    var curTags = [String]()
    
    var requestedProblems = [Problem]()
    
    func downloadProblems(skip: Int) {
        let query = PFQuery(className: "Problems")
        query.limit = 1000
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Problems are successfuly received")
                var problems = [Problem]()
                if let objects = objects {
                    for object in objects {
                        let problem:Problem = Problem()
                        problem.name = object["name"] as! String
                        if let tags = object["tags"] as? [String] {
                            problem.tags = tags
                        }
                        problem.url = object["url"] as! String
                        let websiteName = object["websiteId"] as! String
                        
                        //Problems will be downloaded by Appdelegete. This function is temporary.
                        problem.website = Website(id: "temp_id", name: websiteName, url: "temp_url", contestStatus: "temp_status")
                        
                        problems.append(problem)
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateRequestedProblems(problems, addToAll: true)
                })
            } else {
                print("Error: \(error!) \(error!.userInfo["error"])")
            }
        }
    }
    
    //Returns true if pattern occurs at least once in the text (Case insensitive)
    func match(text: String, pattern: String) -> Bool {
        return text.lowercaseString.rangeOfString(pattern.lowercaseString) != nil
    }
    
    func nameMatch(problem: Problem) -> Bool {
        if curSearchText! == "" {
            return true
        }
        return match(problem.name, pattern: curSearchText!)
    }
    
    func tagMatch(problem: Problem) -> Bool {
        if curTags.count == 0 {
            return true
        }
        for tag in problem.tags {
            if match(tag, pattern: curSearchText!) {
                return true
            }
            for desiredTag in curTags {
                if match(tag, pattern: desiredTag) {
                    return true
                }
            }
        }
        return false
    }
    
    //getRelevance function is currently temporary. Should be improved in the future.
    //calculates the relevance of the problem according to search parameters
    func getRelevance(problem: Problem) -> Int {
        var result = 0
        if nameMatch(problem) {
            result += 8
        }
        if curTags.count > 0 {
            for tag in problem.tags {
                if match(tag, pattern: curSearchText!) {
                    result += 4
                }
                for desiredTag in curTags {
                    if match(tag, pattern: desiredTag) {
                        result += 2
                    }
                }
            }
        }
        return result
    }
    
    func updateRequestedProblems(problems: [Problem], addToAll: Bool) {
        for problem in problems {
            if addToAll {
                allProblems.append(problem)
            }
            if tagMatch(problem) && nameMatch(problem) {
                requestedProblems.append(problem)
            }
        }
        requestedProblems.sortInPlace { (problemA, problemB) -> Bool in
            let relevanceA = getRelevance(problemA)
            let relevanceB = getRelevance(problemB)
            return relevanceA > relevanceB
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if allProblems.count == 0 {
            //KPROBLEMS must be atleast (#problems at parse) / 10
            let KPROBLEMS = 10
            for i in 0 ..< KPROBLEMS {
                downloadProblems(i * 1000)
            }
        } else {
            updateRequestedProblems(allProblems, addToAll: false)
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultsCell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.setProblem(requestedProblems[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        //UIApplication.sharedApplication().openURL(NSURL(string: requestedProblems[indexPath.row].url)!)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            performSegueWithIdentifier("SearchTable_TabBar", sender: cell)
        }
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = self.tableView.indexPathForCell(sender as! UITableViewCell)
        if segue.identifier == "SearchTable_TabBar" {
            if let dest = segue.destinationViewController as? ProblemTabBarController {
                dest.viaSegue_problem = requestedProblems[selectedIndex!.row]
            }
        }
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

    
    // MARK: - Navigation

}
