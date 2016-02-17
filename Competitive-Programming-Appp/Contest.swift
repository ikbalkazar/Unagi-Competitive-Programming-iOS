//
//  Contest.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/14/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class Contest
{
    var event: String!
    var startTime: String!
    var endTime: String!
    var duration: String!
    var url: String!
    var website: String!
    
    init()
    {
        event = ""
        startTime = ""
        endTime = ""
        duration = ""
        url = ""
        website = ""
    }
    
    init( event: String , start: String , end: String , duration: String , url: String )
    {
        self.event = event
        self.startTime = start
        self.endTime = end
        self.duration = duration
        self.url = url
        self.website = identifyWebsite()
        print(url)
    }
    
    func identifyWebsite() -> String
    {
        if event.rangeOfString("Codeforces") != nil {
            return "Codeforces"
        }
        if event.rangeOfString("Cook-off") != nil {
            return "Codechef"
        }
        if event.rangeOfString("Lunchtime") != nil {
            return "Codechef"
        }
        
        if event.rangeOfString("Challenge") != nil {
            return "Codechef"
        }
        
        if event.rangeOfString("Round Match") != nil {
            return "Topcoder"
        }
        
        if event.rangeOfString("ACM") != nil {
            return "ACM"
        }
        
        if event.rangeOfString("IOI") != nil {
            return "IOI"
        }
        
        return "none"
        
    }
    
}