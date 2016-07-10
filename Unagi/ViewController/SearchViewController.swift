//
//  SearchViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 27/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet var searchField: UITextField!
    
    @IBAction func searchButton(sender: AnyObject) {
        performSegueWithIdentifier("toSearchResults", sender: self)
    }
    
    @IBAction func filteredSearch(sender: AnyObject) {
        performSegueWithIdentifier("toSearchResults", sender: self)
    }
    
    // Prepares the ProblemTableViewController according to search parameters.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSearchResults" {
            let destVC = segue.destinationViewController as! ProblemTableViewController
            destVC.requestedProblems = getRequestedProblems()
        }
    }
    
    @IBOutlet var logos: [UIImageView]!
    let websitesToShow = ["Codeforces", "Codechef", "Topcoder"]
    var websiteStatus = [true, true, true]
    
    @IBOutlet var tagField: UITextField!
    var tags = [String]()
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Here!! line 38")
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func addTagButton(sender: AnyObject) {
        if let tag = tagField.text {
            tags.append(tag)
            print("Adding tag!!")
            chosenTagsTable.reloadData()
            tagField.text = ""
        } else {
            //Error messege should be displayed here
            print("Tag does not exists!!")
        }
    }
    

    @IBOutlet var chosenTagsTable: UITableView!
    
    @IBOutlet var switches: [UISwitch]!
    
    //switches are tagged with 10, 11, 12 respectively from left to right
    @IBAction func switchTouched(sender: AnyObject) {
        let senderSwitch = sender as! UISwitch
        let id = senderSwitch.tag % 10
        websiteStatus[id] = !websiteStatus[id]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        tagField.delegate = self
        for imageView in logos {
            print(websitesToShow[imageView.tag])
            imageView.image = UIImage(named: websitesToShow[imageView.tag] + "_Logo.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Problem filtering part.
    
    func match(text: String, pattern: String) -> Bool {
        return text.lowercaseString.rangeOfString(pattern.lowercaseString) != nil
    }
    
    func nameMatch(problem: Problem) -> Bool {
        if searchField == nil || searchField.text == "" {
            return true
        }
        return match(problem.name, pattern: searchField.text!)
    }
    
    func tagMatch(problem: Problem) -> Bool {
        if tags.count == 0 {
            return true
        }
        if let tags = problem.tags as? [String] {
            for tag in tags {
                if match(tag, pattern: searchField.text!) {
                    return true
                }
                for desiredTag in tags {
                    if match(tag, pattern: desiredTag) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    //getRelevance function should be improved.
    //calculates the relevance of the problem according to search parameters
    func getRelevance(problem: Problem) -> Int {
        var result = 0
        if nameMatch(problem) {
            result += 8
        }
        if tags.count > 0 {
            let tags = problem.tags as! [String]
            for tag in tags {
                if match(tag, pattern: searchField.text!) {
                    result += 4
                }
                for desiredTag in tags {
                    if match(tag, pattern: desiredTag) {
                        result += 2
                    }
                }
            }
        }
        return result
    }
    
    private func getRequestedProblems() -> [Problem] {
        var isAllowedWebsite : [String: Bool] = [:]
        for i in 0 ..< websitesToShow.count {
            isAllowedWebsite[websitesToShow[i]] = websiteStatus[i]
        }
        var requestedProblems = [Problem]()
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
        return requestedProblems
    }
    
    //MARK: - Tags table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath)
        cell.textLabel?.text = tags[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            tags.removeAtIndex(indexPath.row)
            chosenTagsTable.reloadData()
        }
    }

}
