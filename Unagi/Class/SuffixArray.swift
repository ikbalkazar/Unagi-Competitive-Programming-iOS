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
        for i in 0 ..< problems.count {
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