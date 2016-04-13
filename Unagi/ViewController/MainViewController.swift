//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse
import CoreData

class MainViewController: UIViewController, UITableViewDelegate {
    
    var solvedProblems = [Problem]()
    var todoProblems = [Problem]()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var problemSolvedLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var worldRankLabel: UILabel!
    @IBOutlet weak var nationalRankLabel: UILabel!
    
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var solvedTable: UITableView!
    
    @IBAction func tempButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("Main_SearchView", sender: self)
    }
    
    private func downloadUserData() {
        var problemMap: [String: Problem] = [:]
        for problem in problems {
            problemMap[problem.objectId] = problem
        }
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            
            if let solvedIds = user?.objectForKey("solved") as? [String] {
                for id in solvedIds {
                    self.solvedProblems.append(problemMap[id]!)
                }
            }
            
            if let todoIds = user?.objectForKey("toDo") as? [String] {
                for id in todoIds {
                    self.todoProblems.append(problemMap[id]!)
                }
            }
            
            self.solvedProblems = self.solvedProblems.reverse()
            self.todoProblems = self.todoProblems.reverse()
            
            self.todoTable.reloadData()
            self.solvedTable.reloadData()
         
            self.problemSolvedLabel.text = String(self.solvedProblems.count)
            
            problemMap.removeAll()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadUserData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(todoTable) {
            return todoProblems.count
        } else {
            return solvedProblems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath)
        if tableView.isEqual(todoTable) {
            cell.textLabel?.text = todoProblems[indexPath.row].name
        } else {
            cell.textLabel?.text = solvedProblems[indexPath.row].name
        }
        return cell
    }
}
