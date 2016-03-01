//
//  Website.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 3/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Website: NSManagedObject {
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.name = ""
        self.objectId = ""
        self.url = ""
        self.contestStatus = ""
    }

}
