//
//  Problem.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import CoreData
import YapDatabase

class Problem: NSObject, NSCoding {
    var name: String!
    var objectId: String!
    var url: String!
    var tags: NSObject?
    var website: Website!
    var isSolved: Bool
    var isTodo: Bool
    
    init(name: String!, withObjectId objectId: String!, andUrl url: String!,
         andTags tags: NSObject?, andWebsite website: Website!, andIsSolved isSolved: Bool, andIsTodo isTodo: Bool) {
        self.name = name
        self.objectId = objectId
        self.url = url
        self.tags = tags
        self.website = website
        self.isSolved = isSolved
        self.isTodo = isTodo
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.objectId = aDecoder.decodeObjectForKey("objectId") as! String
        self.url = aDecoder.decodeObjectForKey("url") as! String
        self.tags = aDecoder.decodeObjectForKey("tags") as? NSObject
        self.website = aDecoder.decodeObjectForKey("website") as! Website
        self.isSolved = aDecoder.decodeObjectForKey("isSolved") as! Bool
        self.isTodo = aDecoder.decodeObjectForKey("isTodo") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name");
        aCoder.encodeObject(self.objectId, forKey: "objectId")
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.tags, forKey: "tags")
        aCoder.encodeObject(self.website, forKey: "website")
        aCoder.encodeObject(self.isSolved, forKey: "isSolved")
        aCoder.encodeObject(self.isTodo, forKey: "isTodo")
    }
}

extension Problem {
    @nonobjc static let collection = String(Problem)
    
    func key() -> String {
        return objectId;
    }
    
    func saveWithTransaction(transaction: YapDatabaseReadWriteTransaction) {
        transaction.setObject(self, forKey: key(), inCollection: Problem.collection)
    }
    
    static func fetch(key: String, withTransaction transaction: YapDatabaseReadTransaction) -> Problem? {
        return transaction.objectForKey(key, inCollection: collection) as? Problem
    }
    
    @nonobjc static var problemForId: [String: Problem]!
    @nonobjc static var problemForName: [String: Problem]!
    @nonobjc static var problemForUrl: [String: Problem]!
    
    static func createProblemMaps() {
        problemForId = [:]
        problemForName = [:]
        problemForUrl = [:]
        for problem in problems {
            problemForId[problem.objectId] = problem
            problemForName[problem.name] = problem
            problemForUrl[problem.url] = problem
        }
    }
    
    static func getNewProblems(after: Int, completion: () -> ()) {
        var map: [String : Website] = [:]
        for website in websites {
            map[website.name] = website
        }
        Request.get(serverHost, andPath: "/problem/after/\(after)", andCompletion: { (json) in
            if let jsonArray = json.array {
                for i in 0 ..< jsonArray.count {
                    let problemData = jsonArray[i];
                    let intId = problemData["id"].intValue
                    let objectId = "\(intId)"
                    let websiteName = problemData["website"].stringValue;
                    let website = map[websiteName]!;
                    let tags: [String] = problemData["tags"].arrayValue.map { $0.string!}
                    problems.append(Problem(name: problemData["name"].stringValue,
                        withObjectId: objectId,
                        andUrl: problemData["url"].stringValue,
                        andTags: tags,
                        andWebsite: website,
                        andIsSolved: false,
                        andIsTodo: false))
                }
            }
            completion()
        })
    }
    
    static func updateProblemEntity(completion: () -> ()) {
        Database.sharedInstance.newConnection().readWithBlock({ (transaction) in
            let keys = transaction.allKeysInCollection(collection) as! [String]
            for key in keys {
                let problem = transaction.objectForKey(key, inCollection: collection) as! Problem
                problems.append(problem)
            }
        })
        getNewProblems(problems.count) { 
            let connection = Database.sharedInstance.newConnection();
            connection.readWriteWithBlock({ (transaction) in
                for problem in problems {
                    problem.saveWithTransaction(transaction)
                }
            })
            print("#problems = \(problems.count)")
            createProblemMaps()
            completion()
        }
    }
}
