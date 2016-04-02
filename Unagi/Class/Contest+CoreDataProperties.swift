//
//  Contest+CoreDataProperties.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contest {

    @NSManaged var objectId: String!
    @NSManaged var name: String!
    @NSManaged var start: String!
    @NSManaged var end: String!
    @NSManaged var duration: NSNumber!
    @NSManaged var url: String!
    @NSManaged var website: Website!

}
