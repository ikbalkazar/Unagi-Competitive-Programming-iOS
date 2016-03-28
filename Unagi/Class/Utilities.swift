//
//  Utilities.swift
//  Unagi
//
//  Created by Harun Gunaydin on 3/27/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let noneWebsite = Website(id: "none", name: "none", url: "none", contestStatus: "0")


func saveToEntity(entityName: String, object: AnyObject) -> Bool {
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
    
    let newObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: context)
    
    let mirrored_object = Mirror(reflecting: object)
    
    for (pKey,pValue) in mirrored_object.children {
        
        guard let key = pKey else {
            continue
        }
        
        if entityName == "Contest" {
            print("key => \(key) value => \(pValue)")
        }
        
        if let value = pValue as? AnyObject {
            newObject.setValue(value, forKey: key)
        } else {
            print("Could not cast from Any to AnyObject? - saving into the Entity \(entityName)")
            print("Problematic Value => \(pValue)")
        }
    }
    
    do {
        try context.save()
        return true
    } catch {
        return false
    }
    
}

func clearEntity(entityName: String) -> Bool {
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let request = NSFetchRequest(entityName: entityName)
    do {
        
        if let objects = try context.executeFetchRequest(request) as? [NSManagedObject] {
            
            for object in objects {
                context.deleteObject(object)
            }
            
            do {
                try context.save()
            } catch {
                return false
            }
            
        } else {
            return false
        }
        
    } catch {
        return false
    }
    
    return true
    
}
