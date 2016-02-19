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
    var duration: Double!//seconds
    var url: String!
    var website: String!
    
    init()
    {
        event = ""
        startTime = ""
        endTime = ""
        duration = 0
        url = ""
        website = ""
    }
    
    init( event: String , start: String , end: String , duration: Double , url: String, website: String )
    {
        self.event = event
        self.startTime = start
        self.endTime = end
        self.duration = duration
        self.url = url
        self.website = website
    }
    
    //getcolor and getimage will be improved by adding more logo pictures.
    
    func getColor() -> UIColor {
        
        // Label contests by their names and return appropriate color
        
        switch(website) {
            case "codeforces.com": return UIColor.blueColor()
            case "codechef.com"  : return UIColor.magentaColor()
            case "topcoder.com"  : return UIColor.redColor()
            case "hackerrank.com": return UIColor.greenColor()
            default:           return UIColor.cyanColor()
        }
    }
    
    func getImage() -> UIImage {
        switch (website) {
            case "codeforces.com":  return UIImage(named: "codeforcesLogo.png")!
            case "codechef.com":    return UIImage(named: "codechefLogo.jpeg")!
            case "topcoder.com":    return UIImage(named: "topcoderLogo.png")!
            case "hackerrank.com":  return UIImage(named: "hackerrankLogo.png")!
            default:            return UIImage(named: "none.jpg")! //Update it once app's logo is available
        }
    }
}