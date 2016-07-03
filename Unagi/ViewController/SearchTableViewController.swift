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
        let solvedProblems = userData.getProblems(kSolvedProblemsKey)
        for problem in solvedProblems {
            solvedMap[problem.objectId] = true
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
        if let problem = problemForId[id] {
            userData.add(problem, key: kSolvedProblemsKey)
            userData.remove(problem, key: kTodoProblemsKey)
        }
    }
    
    func setNotSolved(id: String) {
        solvedMap[id] = false
        if let problem = problemForId[id] {
            userData.remove(problem, key: kSolvedProblemsKey)
        }
    }
    
    func changeSolvedStatus(id: String) {
        if querySolved(id) {
            setNotSolved(id)
        } else {
            setSolved(id)
        }
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
