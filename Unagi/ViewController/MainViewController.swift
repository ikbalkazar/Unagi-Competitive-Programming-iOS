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
    
    var solvedProblems = [Problem]()
    var todoProblems = [Problem]()
    
    @IBOutlet weak var profileImage: UIImageView!
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
        let imageChosen = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileImage.image = imageChosen
        user?.fetchInBackgroundWithBlock({ (user, error) in
            let imageData = UIImageJPEGRepresentation(imageChosen!, 0.1)
            let imageFile = PFFile(data: imageData!)
            user?.setObject(imageFile!, forKey: "profileImage")
            do {
                try user?.save()
            } catch {
                print("Error saving the profile image")
            }
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func downloadUserData() {
        var problemMap: [String: Problem] = [:]
        for problem in problems {
            problemMap[problem.objectId] = problem
        }
        user?.fetchInBackgroundWithBlock({ (user, error) in
            let solvedIds = user?.objectForKey("solved") as? [String]
            if let solvedIds = solvedIds {
                for id in solvedIds {
                    self.solvedProblems.append(problemMap[id]!)
                }
            }
            
            let todoIds = user?.objectForKey("toDo") as? [String]
            if let todoIds = todoIds {
                for id in todoIds {
                    self.todoProblems.append(problemMap[id]!)
                }
            }
            
            if let userImage = user?.valueForKey("profileImage") as? PFFile {
                userImage.getDataInBackgroundWithBlock({ (data, error) in
                    if error == nil {
                        self.profileImage.image = UIImage(data: data!)
                    } else {
                        print("Error getting image data")
                    }
                })
            }
            
            self.solvedProblems = self.solvedProblems.reverse()
            self.todoProblems = self.todoProblems.reverse()
            
            self.todoTable.reloadData()
            self.solvedTable.reloadData()
         
            self.problemSolvedLabel.text = String(self.solvedProblems.count)
            self.usernameLabel.text = user?.objectForKey("username") as? String
            
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
