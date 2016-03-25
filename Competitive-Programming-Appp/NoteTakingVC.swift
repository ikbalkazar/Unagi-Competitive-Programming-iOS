//
//  NoteTakingVC.swift
//  Unagi
//
//  Created by ikbal kazar on 25/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class NoteTakingVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView: UITextView!
    
    var problemObjectIdentifier: String?
    
    override func viewDidLoad() {
        //creates a "done" button on the navigation bar
        //loads the last saved content
        let defaults = NSUserDefaults.standardUserDefaults()
        print(problemObjectIdentifier)
        if let savedStr = defaults.objectForKey(problemObjectIdentifier! + "notes") {
            textView.text = savedStr as! String
        }
    }
    
    func doneButton(sender: AnyObject) {
        textView!.resignFirstResponder()   
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //saves the content permanently
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(textView.text, forKey: problemObjectIdentifier! + "notes")
        defaults.synchronize()
    }
    
    func setProblem(problem: Problem) {
        //since there is a bijection between urls and objectIds, uses urls as an identifier
        problemObjectIdentifier = problem.url
    }
}
