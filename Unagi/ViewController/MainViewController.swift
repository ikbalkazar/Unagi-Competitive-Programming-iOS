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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var problemSolvedLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var worldRankLabel: UILabel!
    @IBOutlet weak var nationalRankLabel: UILabel!
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
                self.profileImageView.image = imageChosen
                NSUserDefaults.standardUserDefaults().setObject(imageChosen, forKey: "profileImage")
            } catch {
                print("Error saving the profile image")
            }
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        profileImageView.image = defaults.objectForKey("profileImage") as? UIImage
        usernameLabel.text = defaults.objectForKey("username") as? String
        solvedProblems = ( defaults.objectForKey("solvedProblems") as! [Problem] ).reverse()
        toDoListProblems = ( defaults.objectForKey("toDoListProblems") as! [Problem] ).reverse()
        solvedTable.reloadData()
        todoTable.reloadData()
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
        return tableView.isEqual(todoTable) ? toDoListProblems.count : solvedProblems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath)
        if tableView.isEqual(todoTable) {
            cell.textLabel?.text = toDoListProblems[indexPath.row].name
        } else {
            cell.textLabel?.text = solvedProblems[indexPath.row].name
        }
        return cell
    }
}
