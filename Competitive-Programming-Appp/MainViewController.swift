//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Parse
import CoreData


class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("Main View Controller - viewDidLoad")
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)
        print("websites.count => \(websites.count)")
        print("self.tableView.reloadData()")
        self.tableView.reloadData()
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("Main View Controller - viewWillAppear")
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
            let data = DataTableViewCellData(imageUrl: "dummy", text: websites[indexPath.row - 1].name!)
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
