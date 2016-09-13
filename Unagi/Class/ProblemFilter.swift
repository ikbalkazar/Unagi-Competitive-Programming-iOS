//
//  ProblemFilter.swift
//  Unagi
//
//  Created by ikbal kazar on 05/09/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

class ProblemFilter {
    
    var searchText: String?
    var allowedWebsites: [String]!
    var tags: [String]!
    
    init(text: String?, withWebsites websites: [String]!, andTags tags: [String]!) {
        self.searchText = text
        self.allowedWebsites = websites
        self.tags = tags
    }
    
    func getProblems(problems: [Problem]) -> [Problem] {
        var isAllowedWebsite : [String: Bool] = [:]
        for i in 0 ..< allowedWebsites.count {
            isAllowedWebsite[allowedWebsites[i]] = true
        }
        var requestedProblems = [Problem]()
        for problem in problems {
            let websiteName = problem.website.name
            if tagMatch(problem) && nameMatch(problem) && isAllowedWebsite[websiteName] == true {
                requestedProblems.append(problem)
            }
        }
        requestedProblems.sortInPlace { (problemA, problemB) -> Bool in
            let relevanceA = getRelevance(problemA)
            let relevanceB = getRelevance(problemB)
            return relevanceA > relevanceB
        }
        return requestedProblems
    }
    
    private func match(text: String, pattern: String) -> Bool {
        return text.lowercaseString.rangeOfString(pattern.lowercaseString) != nil
    }
    
    private func nameMatch(problem: Problem) -> Bool {
        if searchText == nil || searchText == "" {
            return true
        }
        return match(problem.name, pattern: searchText!)
    }
    
    private func tagMatch(problem: Problem) -> Bool {
        if tags.count == 0 {
            return true
        }
        if let tags = problem.tags as? [String] {
            for tag in tags {
                if match(tag, pattern: searchText!) {
                    return true
                }
                for desiredTag in tags {
                    if match(tag, pattern: desiredTag) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    //getRelevance function should be improved.
    //calculates the relevance of the problem according to search parameters
    private func getRelevance(problem: Problem) -> Int {
        var result = 0
        if nameMatch(problem) {
            result += 8
        }
        if tags.count > 0 {
            let tags = problem.tags as! [String]
            for tag in tags {
                if match(tag, pattern: searchText!) {
                    result += 4
                }
                for desiredTag in tags {
                    if match(tag, pattern: desiredTag) {
                        result += 2
                    }
                }
            }
        }
        return result
    }
}
