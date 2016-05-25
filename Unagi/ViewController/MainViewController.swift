//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse
import CoreData
import SafariServices

class MainViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate {
    //changing IBOutlet variable names without fixing their connection to storyboard causes RTE.
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingDeltaLabel: UILabel!
    @IBOutlet weak var deltaImageView: UIImageView!
    @IBOutlet weak var cfHandleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        if let cfHandle = PFUser.currentUser()?.objectForKey("codeforcesHandle") as? String {
            ratingLabel.hidden = false
            ratingDeltaLabel.hidden = false
            deltaImageView.hidden = false
            
            setRatingAndDelta(cfHandle)
        } else {
            cfHandleButton.hidden = true
            ratingLabel.hidden = true
            ratingDeltaLabel.hidden = true
            deltaImageView.hidden = true
        }
    }
    
    @IBAction func cfHandleButtonTouched(sender: AnyObject) {
        let handle = cfHandleButton.titleLabel?.text
        if let url = NSURL(string: "http://codeforces.com/profile/" + handle!) {
            let safari = SFSafariViewController(URL: url)
            self.presentViewController(safari, animated: true, completion: nil)
        }
    }
    
    // MARK: - Collection View Data Source
    
    let imageNames = ["search.png", "layers.png", "tick.png", "agenda.png", "settings.png", "information.png"]
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! MainCollectionViewCell
        cell.backgroundColor = UIColor(hex: "#ffb380")
        
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
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        cell.imageView.layer.cornerRadius = 13
        
        // Configure the cell
        return cell
    }
    
    var curProblems = [Problem]()
    var curTitle: String!
    
    func getProblemList(objectId: String) -> [Problem] {
        let defaults = NSUserDefaults.standardUserDefaults()
        let problemIds = (defaults.objectForKey(objectId) as! [String]).reverse()
        var res = [Problem]()
        for id in problemIds {
            res.append(problemForId[id]!)
        }
        return res
    }
    
    func search() {
        performSegueWithIdentifier("Main_SearchView", sender: self)
    }
    
    func todoList() {
        curProblems = getProblemList("toDoListProblems")
        curTitle = "To Do List"
        performSegueWithIdentifier("Main_ProblemTableVC", sender: self)
    }
    
    func history() {
        curProblems = getProblemList("solvedProblems")
        curTitle = "Solved Problems"
        performSegueWithIdentifier("Main_ProblemTableVC", sender: self)
    }
    
    func calendar() {
        performSegueWithIdentifier("Main_Calendar", sender: self)
    }
    
    func settings() {
        performSegueWithIdentifier("Main_Settings", sender: self)
    }
    
    func about() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        appDel.downloadUserContent(false)
        if segue.identifier! == "Main_ProblemTableVC" {
            let destVC = segue.destinationViewController as! ProblemTableViewController
            destVC.requestedProblems = curProblems
            destVC.title = curTitle
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//Handles codeforces info
extension MainViewController {
    
    func getCodeforcesColor(rating: Int) -> UIColor {
        let colorCuts = [1200, 1400, 1600, 1900, 2200, 2400]
        let colors = ["#808080", "#008000", "#32AAA4", "#0000FF", "#AA00AA", "#FF8C00", "#FF0000"]
        var ptr = 0
        while ptr + 1 < colors.count && colorCuts[ptr] <= rating {
            ptr += 1
        }
        return UIColor(hex: colors[ptr])
    }
    
    func setRatingAndDelta(handle: String) {
        let url = NSURL(string: "http://codeforces.com/api/user.rating?handle=" + handle)!
        let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let query = urlSession.dataTaskWithURL(url) { (data, response, error) in
            if let content = data {
                do {
                    let jsonRes = try NSJSONSerialization.JSONObjectWithData(content, options: NSJSONReadingOptions.MutableContainers)
                    if let result = jsonRes["result"]! as? [AnyObject] {
                        let id = result.count - 1
                        if let lastContest = result[id] as? [String: AnyObject] {
                            let rating = lastContest["newRating"] as! Int
                            let delta = rating - (lastContest["oldRating"] as! Int)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.setLabels(handle, rating: rating, delta: delta)
                            })
                        }
                    }
                } catch {
                    print("Can not convert to json")
                }
            } else {
                print("Data error")
            }
        }
        
        query.resume()
    }
    
    func setLabels(handle: String, rating: Int, delta: Int) {
        let color = getCodeforcesColor(rating)
        
        cfHandleButton.setTitle(handle, forState: UIControlState.Normal)
        cfHandleButton.setTitleColor(color, forState: UIControlState.Normal)
        
        ratingLabel.text = String(rating)
        ratingLabel.textColor = color
        
        if delta < 0 {
            ratingDeltaLabel.text = String(-delta)
            deltaImageView.image = UIImage(named: "decrease.png")
        } else {
            ratingDeltaLabel.text = String(delta)
            deltaImageView.image = UIImage(named: "increase.png")
        }
    }
}
