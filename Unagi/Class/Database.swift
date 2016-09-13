//
//  Database.swift
//  Unagi
//
//  Created by ikbal kazar on 03/09/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import YapDatabase

let kCodeforcesUsernameKey = "kCodeforcesUsernameKey"

class Database {
    static let sharedInstance = Database()
    var database: YapDatabase?
    var sharedConnection: YapDatabaseConnection?
    
    init() {
        var url: NSURL?
        do {
            url = try NSFileManager.defaultManager().URLForDirectory(.ApplicationDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        } catch {
            print("Error getting database file")
        }
        if let dbPath = url?.URLByAppendingPathComponent("unagi.sqlite").path {
            self.database = YapDatabase(path: dbPath)
            self.sharedConnection = self.database?.newConnection();
        }
    }
    
    func newConnection() -> YapDatabaseConnection {
        return (database?.newConnection())!
    }
}
