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
    var localStart: String!
    var endTime: String!
    var localEnd: String!
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
        self.localStart = getLocalDate(start)
        self.endTime = end
        self.localEnd = getLocalDate(end)
        self.duration = duration
        self.url = url
        self.website = website
    }
    
    func getLocalDate(strDate : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.dateFromString(strDate)!
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        return dateFormatter.stringFromDate(date)
    }
    
    func getHourMinuteDuration() -> String {
        let intDur = Int(duration)
        let chours = intDur / 3600
        let cmins = intDur / 60 % 60
        return "\(chours) hours \(cmins) minutes"
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