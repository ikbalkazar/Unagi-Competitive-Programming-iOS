//
//  SearchTableViewCell.swift
//  Unagi
//
//  Created by ikbal kazar on 31/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var problemLogo: UIImageView!
    @IBOutlet var problemName: UILabel!
    
    @IBOutlet var tagsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setProblem(problem: Problem) {
        problemLogo.image = UIImage(named: problem.website.name + "_Logo.png")
        problemName.text = problem.name
        tagsLabel.text = ""
        var isFirst = true
        for tag in problem.tags {
            if !isFirst {
                tagsLabel.text! += ", "
            }
            isFirst = false
            tagsLabel.text! += tag
        }
    }
}
