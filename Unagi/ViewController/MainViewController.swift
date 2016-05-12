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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeNavigationBarItem()
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
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
        
        switch(indexPath.row) {
            
        case 0: tap = UITapGestureRecognizer(target: self, action: #selector(self.search ) )
        default: break
            
        }
        
        cell.addGestureRecognizer(tap)
        
        // Configure the cell
        return cell
    }
    
    func search() {
        
        print("tapped")
        
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
