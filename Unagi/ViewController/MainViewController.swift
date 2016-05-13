//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse
import CoreData

class MainViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate {
    //changing IBOutlet variable names without fixing their connection to storyboard causes RTE.
    @IBOutlet weak var collectionView: UICollectionView!
    
    var problemMap : [String: Problem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
    
        createProblemMap()
    }
    
    override func viewDidDisappear(animated: Bool) {
        //puts the navigation bar back to its place
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func createProblemMap() {
        problemMap = [:]
        for problem in problems {
            problemMap[problem.objectId] = problem
        }
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.greenColor()
        
        cell.layer.cornerRadius = 13
        
        var tap = UIGestureRecognizer()
        
        switch indexPath.row {
        case 0: tap = UITapGestureRecognizer(target: self, action: #selector(self.search))
        case 1: tap = UITapGestureRecognizer(target: self, action: #selector(self.todoList))
        case 2: tap = UITapGestureRecognizer(target: self, action: #selector(self.history))
        case 3: tap = UITapGestureRecognizer(target: self, action: #selector(self.calendar))
        case 4: tap = UITapGestureRecognizer(target: self, action: #selector(self.settings))
        case 5: tap = UITapGestureRecognizer(target: self, action: #selector(self.about))
        default: break
        }
        
        cell.addGestureRecognizer(tap)
        
        // Configure the cell
        return cell
    }
    
    var curProblems = [Problem]()
    
    func getProblemList(objectId: String) -> [Problem] {
        let defaults = NSUserDefaults.standardUserDefaults()
        let problemIds = (defaults.objectForKey(objectId) as! [String]).reverse()
        var res = [Problem]()
        for id in problemIds {
            res.append(problemMap[id]!)
        }
        return res
    }
    
    func search() {
        performSegueWithIdentifier("Main_SearchView", sender: self)
    }
    
    func todoList() {
        curProblems = getProblemList("toDoListProblems")
        performSegueWithIdentifier("Main_ProblemTableVC", sender: self)
    }
    
    func history() {
        curProblems = getProblemList("solvedProblems")
        performSegueWithIdentifier("Main_ProblemTableVC", sender: self)
    }
    
    func calendar() {
        performSegueWithIdentifier("Main_Calendar", sender: self)
    }
    
    func settings() {
        
    }
    
    func about() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "Main_ProblemTableVC" {
            let destVC = segue.destinationViewController as! ProblemTableViewController
            destVC.requestedProblems = curProblems
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 170, height: 170)
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
}
