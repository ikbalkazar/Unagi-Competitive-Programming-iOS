//
//  SuffixArray.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 05/03/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation

class SuffixArray {
    var s : String = ""
    func buildSuffixArray(problems: [Problem]) {
        var start = [Int](count: problems.count, repeatedValue: 0)
        var end = [Int](count: problems.count, repeatedValue: 0)
        for var i = 0; i < problems.count; i++ {
            start[i] = s.length
            s += problems[i].name
            for tag in problems[i].tags {
                s += tag
            }
            end[i] = s.length;
        }
        let n = s.length
        var rank = [Int](count: s.length, repeatedValue: 0)
        
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
}