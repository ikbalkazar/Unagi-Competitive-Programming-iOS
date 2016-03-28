//
//  ProblemStatementVC.swift
//  Unagi
//
//  Created by ikbal kazar on 25/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ProblemStatementVC: UIViewController {
    
    @IBOutlet var webView: UIWebView?
    var problemUrl : String?
    
    override func viewDidLoad() {
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
}
