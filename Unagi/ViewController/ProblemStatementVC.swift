//
//  ProblemStatementVC.swift
//  Unagi
//
//  Created by ikbal kazar on 25/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ProblemStatementVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView?
    var problemUrl : String?
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.mainScreen().bounds.size;
        spinner = UIActivityIndicatorView(frame: CGRectMake(screenSize.width / 2 - 10,
            screenSize.height / 2 - 10, 20, 20))
        spinner?.color = UIColor.blackColor()
        spinner?.hidesWhenStopped = true
        self.view.addSubview(spinner!)
        if let webView = webView {
            webView.scalesPageToFit = true
            webView.contentMode = UIViewContentMode.ScaleToFill
            if let urlStr = problemUrl {
                print("Url = \(urlStr)")
                let url = NSURL(string: urlStr)
                let urlRequest = NSURLRequest(URL: url!)
                webView.loadRequest(urlRequest)
            } else {
                print("Err.. problemUrl = nil")
            }
        } else {
            print("Err.. webView = nil")
        }
    }
    
    func setProblem(problem: Problem) {
        problemUrl = problem.url
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        spinner?.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        spinner?.stopAnimating()
    }
}
