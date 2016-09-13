//
//  ProblemFilterViewController.swift
//  Unagi
//
//  Created by ikbal kazar on 05/09/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ProblemFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let applyItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.applyFilter))
        self.navigationItem.rightBarButtonItems = [applyItem]
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
    }
    
    func addTag() {
        let alert = UIAlertController(title: "Add Tag", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Tag name"
        }
        let confirm = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (alertAction) in
            let textField = alert.textFields![0]
            let text = textField.text!
            if text.length > 0 {
                self.tags.append(text)
                self.tableView.reloadData()
            }
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func applyFilter() {
        performSegueWithIdentifier("unwindToProblemTable", sender: self)
    }
    
    let titleHeaders = ["Websites", "Tags"]
    let websiteNames = ["Codeforces", "Codechef", "Topcoder"]
    var allowedWebsites = [true, true, true]
    var tags: [String] = []
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return websiteNames.count
        case 1:
            return tags.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let view = UIView(frame: CGRectMake(0, 0, screenWidth, 50))
        let label = UILabel(frame: CGRectMake(14, 10, 100, 30))
        label.attributedText = NSAttributedString(string: titleHeaders[section],
                                                  attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(17)])
        view.addSubview(label)
        if section == 1 {
            let button = UIButton(type: UIButtonType.ContactAdd)
            button.frame.origin.x = screenWidth - button.frame.size.width - 14
            button.frame.origin.y = 25 - button.frame.size.height / 2
            button.addTarget(self, action: #selector(self.addTag), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(button)
        }
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProblemFilterViewControllerCell", forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            if allowedWebsites[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            cell.textLabel?.text = websiteNames[indexPath.row]
        case 1:
            cell.textLabel?.text = tags[indexPath.row]
        default:
            print("Table view inconsistency")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (action, indexPath) in
            self.tags.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 0) {
            allowedWebsites[indexPath.row] = !allowedWebsites[indexPath.row]
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}
