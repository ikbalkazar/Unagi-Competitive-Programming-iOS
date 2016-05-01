//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //changing IBOutlet variable names without fixing their connection to storyboard causes RTE.

    var solvedProblemIds = [String]()
    var toDoListProblemIds = [String]()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var solvedTable: UITableView!
    
    @IBAction func tempButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("Main_SearchView", sender: self)
    }
    
    @IBAction func imageSelectButton(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageChosen = info[UIImagePickerControllerOriginalImage] as! UIImage
        PFUser.currentUser()!.fetchInBackgroundWithBlock({ (user, error) in
            let imageData = UIImageJPEGRepresentation(imageChosen, 0.1)
            let imageFile = PFFile(data: imageData!)
            user?.setObject(imageFile!, forKey: "profileImage")
            do {
                try user?.save()
                self.profileImage.image = imageChosen
            } catch {
                print("Error saving the profile image")
            }
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    var problemMap: [String: Problem] = [:]
    
    func refreshTables() {
        let defaults = NSUserDefaults.standardUserDefaults()
        usernameLabel.text = defaults.objectForKey("username") as? String
        solvedProblemIds = ( defaults.objectForKey("solvedProblems") as! [String] ).reverse()
        toDoListProblemIds = ( defaults.objectForKey("toDoListProblems") as! [String] ).reverse()
        for problem in problems {
            problemMap[problem.objectId] = problem
        }
        solvedTable.reloadData()
        todoTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTables()
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTables()
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
        return tableView.isEqual(todoTable) ? toDoListProblemIds.count : solvedProblemIds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath)
        if tableView.isEqual(todoTable) {
            cell.textLabel?.text = problemMap[toDoListProblemIds[indexPath.row]]!.name
        } else {
            cell.textLabel?.text = problemMap[solvedProblemIds[indexPath.row]]!.name
        }
        return cell
    }
}
