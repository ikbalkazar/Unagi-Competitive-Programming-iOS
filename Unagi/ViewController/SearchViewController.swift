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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSearchResults" {
            let destVC = segue.destinationViewController as! SearchTableViewController
            destVC.curSearchText = searchField.text
            destVC.curTags = tags
        }
    }
    
    @IBOutlet var logos: [UIImageView]!
    let websitesToShow = ["Codeforces", "Codechef", "Topcoder"]
    
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
            // handle delete (by removing the data from your array and updating the tableview)
            tags.removeAtIndex(indexPath.row)
            chosenTagsTable.reloadData()
        }
    }

    
    @IBOutlet var chosenTagsTable: UITableView!
    
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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
