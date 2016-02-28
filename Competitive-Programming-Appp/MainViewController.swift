//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse
import CoreData

var websites = [Website]()
var problems = [Problem]()
var problemsUpdated = false

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    func initializeWebsitesFromCoreData() {
        
        print("Get websites from Core Data")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Website")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.executeFetchRequest(request)
            
            for website in results as! [NSManagedObject] {
                
                let name = website.valueForKey("name") as! String
                let url = website.valueForKey("url") as! String
                let objectId = website.valueForKey("objectId") as! String
                let contestStatus = website.valueForKey("contestStatus") as! String
                websites.append( Website(name: name, id: objectId, url: url, contestStatus: contestStatus ) )
            }
            
        } catch {
            print("There is a problem getting websites from Core Data")
        }
    }
    
    func initializeWebsitesFromParse() {
        
        print("Download Websites from Parse")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let query = PFQuery(className: "Websites")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error != nil {
                print("Error downloading websites from Parse DB\n \(error?.userInfo["error"])")
            } else {
                if let sites = objects {
                    for site in sites {
                        let name = site["name"] as! String
                        let id = site.objectId!
                        let url = site["url"] as! String
                        let contestStatus = "\(site["contestStatus"])"
                        print(contestStatus)
                        websites.append( Website(name: name, id: id, url: url, contestStatus: contestStatus) )
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: name + "filtered")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let newSite = NSEntityDescription.insertNewObjectForEntityForName("Website", inManagedObjectContext: context)
                            newSite.setValue(name, forKey: "name")
                            newSite.setValue(id, forKey: "objectId")
                            newSite.setValue(url, forKey: "url")
                            newSite.setValue("\(contestStatus)", forKey: "contestStatus")
                            do {
                                try context.save()
                            } catch {
                                print("Error saving into Core Data - Website Database")
                            }
                        })
                        
                    }
                    if websites.count == sites.count {
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "WebsiteTableDownloaded")
                        
                        self.tableView.reloadData()
                        
                    }
                }
            }
            
        }
        
    }
    
    func updateProblemsDBOnCoreData() {
        
        //Does not work as desired right now.
        
        print("Update Problems DataBase on Core Data with new entries in Problem DataBase on Parse")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let query = PFQuery(className: "Problems")
        
        //Since this is the maximum limit we should do this in a loop until there will be no result coming from "query"
        query.limit = 1000
        
        if let lastUpdateTime = NSUserDefaults.standardUserDefaults().objectForKey("ProblemsDB_LastUpdateTime") {
            query.whereKey("updatedAt", greaterThan: lastUpdateTime)
        }
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                
                if let objects = objects {
                    
                    print("size of problems => \(objects.count)")
                    
                    for problem in objects {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let newProblem = NSEntityDescription.insertNewObjectForEntityForName("Problem", inManagedObjectContext: context)
                        
                            newProblem.setValue(problem.objectId!, forKey: "objectId")
                        
                            if let name = problem["name"] as? String {
                                newProblem.setValue(name, forKey: "name")
                            }
                            
                            if let url = problem["url"] as? String {
                                newProblem.setValue(url, forKey: "url")
                            }
                            
                            if let tags = problem["tags"] as? [String] {
                                newProblem.setValue(tags, forKey: "tags")
                            }
                            
                            if let contestId = problem["contestId"] as? String {
                                newProblem.setValue(contestId, forKey: "contestId")
                            }
                            
                            if let solutionUrl = problem["solutionUrl"] as? String {
                                newProblem.setValue(solutionUrl, forKey: "solutionUrl")
                            }
                            
                            if let difficulty = problem["difficulty"] as? Int16 {
                            //    newProblem.setValue(difficulty, forKey: "difficulty")
                            }
                            
                            if let rating = problem["rating"] as? Double {
                            //    newProblem.setValue(rating, forKey: "rating")
                            }
                            
                            if let websiteId = problem["websiteId"] as? String {
                                newProblem.setValue(websiteId, forKey: "websiteId")
                            }
                            
                            newProblem.setValue(NSDate(), forKey: "updatedAt")
                            
                            do {
                                try context.save()
                            } catch {
                                print("Error saving into Core Data - Problems Database")
                            }
                        
                        })
                        
                    }
                    
                }

                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "ProblemsDB_LastUpdateTime")
                
            } else {
                print("Problems Data Base could not updated!!! Check the internet connection")
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)
        
        if NSUserDefaults.standardUserDefaults().objectForKey("WebsiteTableDownloaded") != nil {
            
            if websites.count == 0 {
                initializeWebsitesFromCoreData()
            }
            
        } else {
            initializeWebsitesFromParse()
        }
        
        updateProblemsDBOnCoreData()
        
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


extension MainViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
}

extension MainViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //websites + overall search cell
        return websites.count + 1
    }
     
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(DataTableViewCell.identifier) as! DataTableViewCell
        if indexPath.row == 0 {
            let data = DataTableViewCellData(imageUrl: "dummy", text: "Overall Search")
            cell.setData(data)
        } else {
            let data = DataTableViewCellData(imageUrl: "dummy", text: websites[indexPath.row - 1].name)
            cell.setData(data)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let searchView = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as!     SearchViewController
            self.navigationController?.pushViewController(searchView, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
            let subContentsVC = storyboard.instantiateViewControllerWithIdentifier("SubContentsViewController") as! SubContentsViewController
            self.navigationController?.pushViewController(subContentsVC, animated: true)
        }
    }
}
