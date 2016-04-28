//
//  LoadingViewController.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/20/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
//import FillableLoaders

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let height = UIScreen.mainScreen().bounds.height
        let width =  UIScreen.mainScreen().bounds.width
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, height/2)
        CGPathAddLineToPoint(path, nil, width + 100, height/2)
        CGPathAddLineToPoint(path, nil, width + 100, height*2)
        CGPathAddLineToPoint(path, nil, 0, height*2)
        CGPathCloseSubpath(path)
        
        let loader = WavesLoader.createLoaderWithPath(path: path)
        
        loader.loaderColor = UIColor.redColor()
        
        loader.showLoader()*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
