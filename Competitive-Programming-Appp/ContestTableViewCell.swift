//
//  ContestTableViewCell.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 18/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ContestTableViewCell: UITableViewCell {
    
    var contestWebsite: String = ""
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet weak var contestNameLabel: UILabel!
    @IBAction func addToCalendar(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
