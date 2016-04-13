//
//  SearchTableViewCell.swift
//  Unagi
//
//  Created by ikbal kazar on 31/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import Parse

class SearchTableViewCell: UITableViewCell {
    
    var delegate: UITableViewController?
    var problem: Problem?
    @IBOutlet var problemLogo: UIImageView!
    @IBOutlet var problemNameLabel: UILabel!
    
    @IBOutlet var tagsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: title, style: .Default, handler: { (action) -> Void in
            self.delegate?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        delegate?.presentViewController(alert, animated: true, completion: nil)
    }

    
    //adds the problem to user's to do list
    @IBAction func addButton(sender: AnyObject) {
        if PFUser.currentUser()!.authenticated {
            PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
                if error == nil {
                    var todo = user?.objectForKey("toDo") as? [String]
                    if todo == nil {
                        todo = [String]()
                    }
                    if !(todo?.contains(self.problem!.objectId))! {
                        todo?.append((self.problem?.objectId)!)
                    }
                    user?.setValue(todo, forKey: "toDo")
                    do {
                        try user?.save()
                        self.displayAlert("Successful", message: "Problem added to to-do list")
                    } catch {
                        print("Error when saving")
                    }
                }
            })
        } else {
            print("Error User is not authenticated, cant add to todo list")
        }
    }
    
    func setProblemForCell(problem: Problem) {
        self.problem = problem
        problemLogo.image = UIImage(named: problem.website.name + "_Logo.png")
        problemNameLabel.text = problem.name
        
        tagsLabel.text = ""
        var isFirst = true
        if let tags = problem.tags as? [String] {
            for tag in tags {
                if !isFirst {
                    tagsLabel.text! += ", "
                }
                isFirst = false
                tagsLabel.text! += tag
            }
        }
    }
}
