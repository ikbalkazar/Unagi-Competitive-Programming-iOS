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

    var curSearchText : String?
    var curTags = [String]()
    var isAllowedWebsite: [String: Bool] = [:]
    
    var requestedProblems = [Problem]()
    var solvedMap: [String: Bool] = [:]
    
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
        if let tags = problem.tags as? [String] {
            for tag in tags {
                if match(tag, pattern: curSearchText!) {
                    return true
                }
                for desiredTag in curTags {
                    if match(tag, pattern: desiredTag) {
                        return true
                    }
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
            let tags = problem.tags as! [String]
            for tag in tags {
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
    
    func updateRequestedProblems(problems: [Problem]) {
        for problem in problems {
            let websiteName = problem.website.name
            if tagMatch(problem) && nameMatch(problem) && isAllowedWebsite[websiteName] == true {
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
    
    //can be moved to AppDelegate with the Map
    func getSolvedList() {
        user?.fetchInBackgroundWithBlock({ (user, error) in
            let solvedIds = user?.objectForKey("solved") as? [String]
            if solvedIds != nil {
                for problemId in solvedIds! {
                    print("Initializing to solved \(problemId)")
                    self.solvedMap[problemId] = true
                }
            }
            self.tableView.reloadData()
        })
    }
    
    private func querySolved(id: String) -> Bool{
        if let value = solvedMap[id] {
            if value == true {
                print("Turns out solved... \(id)")
            }
            return value
        } else {
            return false
        }
    }
    
    func setSolved(id: String) {
        print("Setting solved \(id)")
        solvedMap[id] = true
        user?.fetchInBackgroundWithBlock({ (user, error) in
            var solvedIds = user?.objectForKey("solved") as? [String]
            if solvedIds == nil {
                solvedIds = [String]()
            }
            solvedIds!.append(id)
            user?.setObject(solvedIds!, forKey: "solved")
            do {
                try user?.save()
            } catch {
                print("Error saving")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRequestedProblems(problems)
        solvedMap = [:]
        getSolvedList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestedProblems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let problem = requestedProblems[indexPath.row]
        var identifier = "searchResultsCell"
        if querySolved(problem.objectId) {
            identifier += "Solved"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SearchTableViewCell
        cell.setProblemForCell(problem)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
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

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let solvedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Solved") { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            
            print(self.requestedProblems[indexPath.row].objectId)
            self.setSolved(self.requestedProblems[indexPath.row].objectId)
            self.tableView.reloadData()
        }
        return [solvedAction]
    }

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
