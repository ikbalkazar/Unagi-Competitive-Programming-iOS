//
//  LeftViewController.swift
//

import UIKit

enum LeftMenu: Int {
    case Main = 0
    case Swift
    case Friends
    case Go
    case NonMenu
    case Contests
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class LeftViewController : UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Main", "Swift", "Friends", "Go", "NonMenu", "Upcoming Contests"]
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var friendsTableViewController: UIViewController!
    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    var contestTableViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var profileImageHash: Int!
    var backgroundImageHash: Int!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewControllerWithIdentifier("SwiftViewController") as! SwiftViewController
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)
        
        let contestTableViewController = storyboard.instantiateViewControllerWithIdentifier("ContestTableViewController") as! ContestTableViewController
        self.contestTableViewController = UINavigationController(rootViewController: contestTableViewController)
        
        let friendsTableViewController = storyboard.instantiateViewControllerWithIdentifier("FriendsTableViewController") as! FriendsTableViewController
        self.friendsTableViewController = UINavigationController(rootViewController: friendsTableViewController)
        
        let goViewController = storyboard.instantiateViewControllerWithIdentifier("GoViewController") as! GoViewController
        self.goViewController = UINavigationController(rootViewController: goViewController)
        
        let nonMenuController = storyboard.instantiateViewControllerWithIdentifier("NonMenuController") as! NonMenuController
        nonMenuController.delegate = self
        
        let UpcomingContestsContoller = storyboard.instantiateViewControllerWithIdentifier("ContestTableViewController") as! ContestTableViewController
        UpcomingContestsContoller.delegate = self
        
        
        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "openActionSheet:")
        profileImageHash = tap.hash
        self.imageHeaderView.profileImage.addGestureRecognizer(tap)
        self.imageHeaderView.profileImage.userInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: "openActionSheet:")
        backgroundImageHash = tap2.hash
        self.imageHeaderView.backgroundImage.addGestureRecognizer(tap2)
        self.imageHeaderView.backgroundImage.userInteractionEnabled = true
        
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeProfilePicture(type: UIImagePickerControllerSourceType, forImage imageName: String)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.restorationIdentifier = imageName
        imagePicker.delegate = self
        imagePicker.sourceType = type
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if picker.restorationIdentifier == "ProfileImage" {
            imageHeaderView.profileImage.image = image
        } else {
            imageHeaderView.backgroundImage.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openActionSheet(sender: UITapGestureRecognizer)
    {
        let imageName = ( sender.hash == profileImageHash) ? "ProfileImage" : "BackgroundImage"
        print(imageName)
        let optionMenu = UIAlertController(title: nil, message: "Choose Image From", preferredStyle: .ActionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .Default, handler: { (alert) -> Void in
            
            self.changeProfilePicture(UIImagePickerControllerSourceType.Camera, forImage: imageName)
        })
        let library = UIAlertAction(title: "Photo Library", style: .Default, handler: { (alert) -> Void in
            
            self.changeProfilePicture(UIImagePickerControllerSourceType.PhotoLibrary, forImage: imageName)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
            
        }
        
        optionMenu.addAction(camera)
        optionMenu.addAction(library)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func changeViewController(menu: LeftMenu) {
        print("Changing the view!!")
        switch menu {
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Swift:
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .Friends:
            self.slideMenuController()?.changeMainViewController(self.friendsTableViewController, close: true)
        case .Go:
            self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
        case .NonMenu:
            self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
        case .Contests:
            self.slideMenuController()?.changeMainViewController(self.contestTableViewController, close: true)
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Swift, .Friends, .Go, .NonMenu, .Contests:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Swift, .Friends, .Go, .NonMenu, .Contests:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}

extension LeftViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
