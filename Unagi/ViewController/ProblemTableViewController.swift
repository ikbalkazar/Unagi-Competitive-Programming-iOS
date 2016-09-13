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
    var requestedProblems: [Problem] = []
    var filteredProblems: [Problem] = []
    var selectedProblem: Problem?

    var websites: [String] = ["Codeforces", "Codechef", "Topcoder"]
    var tags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestedProblems = requestedProblems.reverse()
        filteredProblems = requestedProblems;
        let filterItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize,
                              target: self, action: #selector(self.filterOptionsTouched))
        let clearItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Rewind, target: self, action: #selector(self.clearFilter))
        self.navigationItem.rightBarButtonItems = [filterItem, clearItem]
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func unwindToProblemTable(segue: UIStoryboardSegue) {
        let vc = segue.sourceViewController as! ProblemFilterViewController
        websites = []
        for i in 0 ..< 3 {
            if vc.allowedWebsites[i] {
                websites.append(vc.websiteNames[i])
            }
        }
        tags = []
        for tag in vc.tags {
            tags.append(tag)
        }
        refreshTable("")
    }
    
    func clearFilter() {
        websites = ["Codeforces", "Codechef", "Topcoder"]
        tags = []
        refreshTable("")
    }
    
    func filterOptionsTouched() {
        performSegueWithIdentifier("toProblemFilterView", sender: self)
    }
    
    func changeSolvedStatus(problem: Problem) {
        Database.sharedInstance.sharedConnection?.readWriteWithBlock({ (transaction) in
            problem.isSolved = !problem.isSolved
            problem.saveWithTransaction(transaction)
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProblems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let problem = filteredProblems[indexPath.row]
        var identifier = "searchResultsCell"
        if problem.isSolved {
            identifier += "Solved"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SearchTableViewCell
        cell.setProblemForCell(problem)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProblem = filteredProblems[indexPath.row]
        self.performSegueWithIdentifier("SearchTable_TabBar", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchTable_TabBar" {
            if let dest = segue.destinationViewController as? ProblemTabBarController {
                dest.viaSegue_problem = selectedProblem
            }
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let problem = self.filteredProblems[indexPath.row]
        
        var actionTitle = ""
        if problem.isSolved {
            actionTitle = "Not Solved"
        } else {
            actionTitle = "Solved"
        }
        
        let solvedAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: actionTitle) { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            
            self.changeSolvedStatus(self.filteredProblems[indexPath.row])
            self.tableView.reloadData()
        }
        return [solvedAction]
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let problem = filteredProblems[indexPath.row]
        let problemCell = cell as! SearchTableViewCell
        problemCell.addButtonOutlet.hidden = problem.isTodo
    }
    
    func refreshTable(searchText: String!) {
        let filter = ProblemFilter(text: searchText, withWebsites: websites, andTags: tags);
        filteredProblems = filter.getProblems(requestedProblems);
        self.tableView.reloadData()
    }
}

extension ProblemTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        refreshTable(searchText)
    }
}
