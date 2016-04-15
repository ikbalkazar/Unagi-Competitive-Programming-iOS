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
        loadNotes()
    }
    
    func doneButton() {
        textView!.resignFirstResponder()
        saveNotes()
    }
    
    func loadNotes() {
        print(problemObjectIdentifier)
        if let savedStr = NSUserDefaults.standardUserDefaults().objectForKey(problemObjectIdentifier! + "notes") {
            textView.text = savedStr as! String
        }
    }
    
    func saveNotes() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(textView.text, forKey: problemObjectIdentifier! + "notes")
        defaults.synchronize()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //saves the content permanently
        saveNotes()
    }
    
    func setProblem(problem: Problem) {
        //since there is a bijection between urls and objectIds, uses urls as an identifier
        problemObjectIdentifier = problem.url
    }
}
