//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var mainContents = ["codeforces.com" , "topcoder.com" , "codechef.com" , "hackerrank.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)
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
        return self.mainContents.count
    }
     
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(DataTableViewCell.identifier) as! DataTableViewCell
        let text = mainContents[indexPath.row].uppercaseString
        let data = DataTableViewCellData(imageUrl: "dummy", text: text.substringToIndex(text.startIndex.advancedBy(text.length-4)))
        cell.setData(data)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewControllerWithIdentifier("SubContentsViewController") as! SubContentsViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}
