//
//  FilterTableViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 21/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
var includeExcludeOrder_ = false
class FilterTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func includeExcludeAll(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        includeExcludeOrder_ = !includeExcludeOrder_
        for website in websites {
                defaults.setObject(includeExcludeOrder_, forKey: website.name! + "filtered")
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filtertablecell", forIndexPath: indexPath) as! FilterTableViewCell
        cell.label.text = websites[indexPath.row].name
        cell.awakeFromNib()
        return cell
    }
}
