//
//  SearchTableViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 27/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

class ProblemTableViewController: UITableViewController {
    
    var requestedProblems = [Problem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getSolvedList()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Solved problems data of the user part
    
    var solvedMap: [String: Bool] = [:]
    
    func getSolvedList() {
        solvedMap.removeAll()
        let defaults = NSUserDefaults.standardUserDefaults()
        let solvedProblemIds = defaults.objectForKey("solvedProblems") as! [String]
        print("Getting solved List!!!")
        print(solvedProblemIds)
        for id in solvedProblemIds {
            solvedMap[id] = true
        }
    }
    
    private func querySolved(id: String) -> Bool {
        if let value = solvedMap[id] {
            return value
        } else {
            return false
        }
    }
    
    func setSolved(id: String) {
        print("Setting solved \(id)")
        solvedMap[id] = true
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            var solvedIds = user?.objectForKey("solved") as? [String]
            if solvedIds == nil {
                solvedIds = [String]()
            }
            solvedIds!.append(id)
            user?.setObject(solvedIds!, forKey: "solved")
            
            var todoIds = user?.objectForKey("toDo") as? [String]
            if todoIds == nil {
                todoIds = [String]()
            }
            if todoIds!.contains(id) {
                todoIds!.removeAtIndex((todoIds?.indexOf(id))!)
            }
            
            user?.setObject(todoIds!, forKey: "toDo")
            
            user?.saveInBackground()
        })
    }
    
    func setNotSolved(id: String) {
        solvedMap[id] = false
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            var solvedIds = user?.objectForKey("solved") as? [String]
            if solvedIds == nil {
                solvedIds = [String]()
            }
            //finds an element equal to id and removes it
            for i in 0 ..< solvedIds!.count {
                if solvedIds![i] == id {
                    solvedIds?.removeAtIndex((solvedIds?.startIndex.advancedBy(i))!)
                    break
                }
            }
            user?.setObject(solvedIds!, forKey: "solved")
            do {
                try user?.save()
            } catch {
                print("Error saving")
            }
        })
    }
    
    //Updates the NSUserDefaults solved problems data according to last change on id
    func fixUserDefaultsUserSolvedData(id: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var solvedProblemIds = defaults.objectForKey("solvedProblems") as! [String]
        if solvedProblemIds.contains(id) {
            let index = solvedProblemIds.indexOf(id)
            solvedProblemIds.removeAtIndex(index!)
        } else {
            solvedProblemIds.append(id)
        }
        print(solvedProblemIds)
        defaults.setObject(solvedProblemIds, forKey: "solvedProblems")
        defaults.synchronize()
    }
    
    func changeSolvedStatus(id: String) {
        if querySolved(id) {
            setNotSolved(id)
        } else {
            setSolved(id)
        }
        fixUserDefaultsUserSolvedData(id)
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
        cell.delegate = self
        
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

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let problemId = self.requestedProblems[indexPath.row].objectId
        
        var actionTitle = ""
        if querySolved(problemId) {
            actionTitle = "Not Solved"
        } else {
            actionTitle = "Solved"
        }
        
        let solvedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: actionTitle) { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            
            self.changeSolvedStatus(self.requestedProblems[indexPath.row].objectId)
            self.tableView.reloadData()
        }
        return [solvedAction]
    }
}
