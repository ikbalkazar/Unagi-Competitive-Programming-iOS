//
//  CodeforcesSolvedGetter.swift
//  Unagi
//
//  Created by ikbal kazar on 12/09/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import SwiftyJSON

class SolvedGetter {
    class func getCodeforces(completion: (problemIds: [String]) -> ()) {
        if let username = NSUserDefaults.standardUserDefaults().objectForKey(kCodeforcesUsernameKey) as? String {
            Request.get("http://codeforces.com", andPath: "/api/user.status?handle=\(username)") { (json) in
                let submissons = json["result"].arrayValue
                var resIds: [String] = []
                for i in 0 ..< submissons.count {
                    if submissons[i]["verdict"].stringValue == "OK" {
                        let problem = submissons[i]["problem"]
                        let url = "https://www.codeforces.com/problemset/problem/\(problem["contestId"])/\(problem["index"])"
                        if let problem = Problem.problemForUrl[url] {
                            resIds.append(problem.objectId)
                        }
                    }
                }
                completion(problemIds: resIds)
            }
        }
    }
}
