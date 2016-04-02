//
//  Problem+CoreDataProperties.swift
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

extension Problem {

    @NSManaged var name: String!
    @NSManaged var objectId: String!
    @NSManaged var url: String!
    @NSManaged var tags: NSObject?
    @NSManaged var solutionUrl: String?
    @NSManaged var website: Website!

}
