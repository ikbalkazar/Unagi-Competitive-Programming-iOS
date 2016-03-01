//
//  Website+CoreDataProperties.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 3/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Website {

    @NSManaged var contestStatus: String?
    @NSManaged var name: String?
    @NSManaged var objectId: String?
    @NSManaged var url: String?

}
