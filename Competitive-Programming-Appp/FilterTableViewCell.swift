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
    
    @IBAction func `switch`(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(switchButton.on, forKey: label.text! + "filtered")
        defaults.synchronize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if label.text != "label" {
        
            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.objectForKey(label.text! + "filtered") == nil {
                // First time encounter
                // Initialize here since it makes more sense
                defaults.setObject(true, forKey: label.text! + "filtered" )
            } else {
                switchButton.setOn(defaults.objectForKey(label.text! + "filtered") as! Bool , animated: true)
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
