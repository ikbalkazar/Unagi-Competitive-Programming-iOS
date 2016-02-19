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
    
    init( event: String , start: String , end: String , duration: Double , url: String )
    {
        self.event = event
        self.startTime = start
        self.endTime = end
        self.duration = duration
        self.url = url
        self.website = identifyWebsite()
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
    
    func getColor() -> UIColor {
        
        // Label contests by their names and return appropriate color
        
        switch(website) {
            case "Codeforces": return UIColor.blueColor()
            case "Codechef"  : return UIColor.magentaColor()
            case "Topcoder"  : return UIColor.redColor()
            case "Hackerrank": return UIColor.greenColor()
            case "ACM" :       return UIColor.yellowColor()
            case "IOI" :       return UIColor.purpleColor()
            default:           return UIColor.cyanColor()
        }
    }
    
    func getImage() -> UIImage {
        switch (website) {
            case "Codeforces":  return UIImage(named: "codeforcesLogo.png")!
            case "Codechef":    return UIImage(named: "codechefLogo.jpeg")!
            case "Topcoder":    return UIImage(named: "topcoderLogo.png")!
            case "Hackerrank":  return UIImage(named: "hackerrankLogo.png")!
            case "ACM":         return UIImage(named: "acmicpcLogo.png")!
            case "IOI":         return UIImage(named: "ioiLogo.png")!
            default:            return UIImage(named: "none.jpg")! //Update it once app's logo is available
        }
    }
}