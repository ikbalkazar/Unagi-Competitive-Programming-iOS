//
//  FilterTableViewCell.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 21/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import CoreData

class FilterTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    
    @IBOutlet var switchButton: UISwitch!
    
    func isSource(website: String) -> Bool {
        if let outcome = NSUserDefaults.standardUserDefaults().objectForKey(website) {
            print(outcome as! Bool)
            return outcome as! Bool
        } else {
            print("Line 27")
            //it means first time ever
            return true
        }
    }
    
    func setSource(website: String, value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: website)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func `switch`(sender: AnyObject) {
        print("setting")
        print(switchButton.on)
        setSource(label.text!, value: switchButton.on)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Line 48/ FilterTableViewCell")
        //setSource(label.text!, value: false)
        switchButton.setOn(isSource(label.text!), animated: true)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
