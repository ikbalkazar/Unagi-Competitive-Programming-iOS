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
                websites.append( Website(name: name, id: objectId, url: url ) )
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
                        websites.append( Website(name: name, id: id, url: url) )
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: name + "filtered")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let newSite = NSEntityDescription.insertNewObjectForEntityForName("Website", inManagedObjectContext: context)
                            newSite.setValue(name, forKey: "name")
                            newSite.setValue(id, forKey: "objectId")
                            newSite.setValue(url, forKey: "url")
                            do {
                                try context.save()
                            } catch {
                                print("Error saving into Core Data")
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
        
        //Update Problems
        
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
        return websites.count
    }
     
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(DataTableViewCell.identifier) as! DataTableViewCell
        let data = DataTableViewCellData(imageUrl: "dummy", text: websites[indexPath.row].name)
        cell.setData(data)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewControllerWithIdentifier("SubContentsViewController") as! SubContentsViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}
