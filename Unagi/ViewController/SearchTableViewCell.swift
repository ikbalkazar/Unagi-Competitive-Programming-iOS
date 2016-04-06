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
    
    var problem: Problem?
    var didSolved: Bool?
    @IBOutlet var problemLogo: UIImageView!
    @IBOutlet var problemName: UILabel!
    
    @IBOutlet var tagsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        didSolved = false
        backgroundColor = UIColor.whiteColor()
    }
    
    //adds the problem to user's to do list
    @IBAction func addButton(sender: AnyObject) {
        if user!.authenticated {
            user?.fetchInBackgroundWithBlock({ (user, error) in
                if error == nil {
                    var todo = user?.objectForKey("toDo") as? [String]
                    if todo == nil {
                        todo = [String]()
                    }
                    if !(todo?.contains(self.problem!.objectId))! {
                        todo?.append((self.problem?.objectId)!)
                    }
                    print(todo)
                    user?.setValue(todo, forKey: "toDo")
                    do {
                        try user?.save()
                    } catch {
                        print("Error when saving")
                    }
                }
            })
        } else {
            print("Error User is not authenticated, cant add to todo list")
        }
    }
    
    func setProblemForCell(_problem: Problem) {
        problem = _problem
        problemLogo.image = UIImage(named: problem!.website.name + "_Logo.png")
        problemName.text = problem!.name
        
        tagsLabel.text = ""
        var isFirst = true
        if let tags = problem!.tags as? [String] {
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
