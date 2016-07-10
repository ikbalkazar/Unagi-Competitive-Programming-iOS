//
//  UserData.swift
//  
//  Created by ikbal kazar on 27/06/16.
//

import UIKit
import Parse

let kSolvedProblemsKey = "solvedProblems"
let kTodoProblemsKey = "todoProblems"

class UserData: NSObject {
    
    var data: [String: AnyObject]!
    
    override init() {
        super.init()
        data = [:]
    }
    
    func load(completion: () -> ()) {
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            if error != nil {
                // Error!
            } else {
                var solvedProblemsIds = user?.objectForKey("solved") as? [String]
                if solvedProblemsIds == nil {
                    solvedProblemsIds = [String]()
                }
                
                var todoProblemsIds = user?.objectForKey("toDo") as? [String]
                if todoProblemsIds == nil {
                    todoProblemsIds = [String]()
                }
                
                self.data[kSolvedProblemsKey] = self.convertToProblems(solvedProblemsIds!)
                self.data[kTodoProblemsKey] = self.convertToProblems(todoProblemsIds!)
                
                completion()
            }
        })
    }
    
    func save() {
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) in
            if error != nil {
                // Error!
            } else {
                user?.setObject(self.convertToIds(self.data[kSolvedProblemsKey]! as! [Problem]), forKey: "solved")
                user?.setObject(self.convertToIds(self.data[kTodoProblemsKey]! as! [Problem]), forKey: "toDo")
                do {
                    try user?.save()
                } catch {
                    print("Could not save user data !!!")
                }
            }
        })
    }
    
    func getProblems(forKey: String) -> [Problem] {
        var problems = self.data[forKey] as? [Problem]
        if problems == nil {
            problems = [Problem]()
        }
        return problems!
    }
    
    func add(problem: Problem, key: String) {
        var problems = data[key] as? [Problem]
        if !problems!.contains(problem) {
            problems!.append(problem)
            data[key] = problems
            save()
        }
    }
    
    func remove(problem: Problem, key: String) {
        var problems = data[key] as? [Problem]
        if problems!.contains(problem) {
            problems!.removeAtIndex(problems!.indexOf(problem)!)
            data[key] = problems
            save()
        }
    }
}

// Converters.
extension UserData {
    func convertToProblems(ids: [String]) -> [Problem] {
        var problems: [Problem] = []
        for id in ids {
            if problemForId[id] != nil {
                problems.append(problemForId[id]!)
            }
        }
        return problems;
    }
    
    func convertToIds(problems: [Problem]) -> [String] {
        var ids: [String] = []
        for problem in problems {
            ids.append(problem.objectId)
        }
        return ids
    }
}




