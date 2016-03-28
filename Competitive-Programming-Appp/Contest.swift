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
    var objectId: String!
    var name: String!
    var start: String!
    var end: String!
    var duration: Double! // in seconds
    var url: String!
    var website: Website!
    
    init()
    {
        objectId = ""
        name = ""
        start = ""
        end = ""
        duration = 0
        url = ""
        website = noneWebsite
    }
    
    init( id: String , name: String , start: String , end: String , duration: Double , url: String, website: Website )
    {
        self.objectId = id
        self.name = name
        self.start = start
        self.end = end
        self.duration = duration
        self.url = url
        self.website = website
    }
    
    func localStart() -> String {
        return self.getLocalDate(start)
    }
    
    func localEnd() -> String {
        return self.getLocalDate(end)
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
    
    func getImage() -> UIImage {
        
        if let image = UIImage(named: website.name! + "_Logo.png") {
            return image
        }
        return UIImage(named: "none.png")!
        
    }
    
    func getImage(website website: String) -> UIImage {
        
        if let image = UIImage(named: website + "_Logo.png") {
            return image
        }
        return UIImage(named: "none.png")!
    }
    
    
}