//
//  Contest.swift
//  Unagi
//
//  Created by Harun Gunaydin on 4/1/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import Foundation
import UIKit


class Contest {
    
    var objectId: String!
    var name: String!
    var start: String!
    var end: String!
    var duration: NSNumber!
    var url: String!
    var website: Website!
    
    func localStart() -> String {
        return self.getLocalDate(start!)
    }
    
    func localEnd() -> String {
        return self.getLocalDate(end!)
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
        let intDur = Int(duration!)
        let chours = intDur / 3600
        let cmins = intDur / 60 % 60
        return "\(chours) hours \(cmins) minutes"
    }
    
    func getImage() -> UIImage {
        
        if let image = UIImage(named: website!.name! + "_Logo.png") {
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

func updateFilteredContestsArray() {
    
    filteredContests.removeAll()
    
    for contest in contests {
         
         if NSUserDefaults.standardUserDefaults().objectForKey(contest.website.name + "filtered") as! Bool {
            filteredContests.append(contest)
         }
        
    }
    
}

func downloadContestsUsingClistByAPI(sender: ContestTableViewController) {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let now = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateFrom : String = dateFormatter.stringFromDate(now)
    
    let url:NSURL = NSURL(string: "https://clist.by/api/v1/json/contest/?start__gte=" + dateFrom + "&username=ikbalkazar&api_key=b66864909a08b2ddf96b258a146bd15c2db6a469&order_by=start")!
    
    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    let myQuery = urlSession.dataTaskWithURL(url, completionHandler: {
        data, response, error -> Void in
        
        if let content = data {
            do {
                let jsonRes = try NSJSONSerialization.JSONObjectWithData(content, options: NSJSONReadingOptions.MutableContainers)
                let objects = jsonRes["objects"]!!
                
                print("Json convertion is successful and size => \(objects.count)")
                
                for i in 0 ..< objects.count {
                    
                    let newContest = Contest()
                    
                    newContest.name = objects[i]["event"] as? String
                    newContest.start = objects[i]["start"] as? String
                    newContest.end = objects[i]["end"] as? String
                    newContest.duration = objects[i]["duration"] as? Double
                    newContest.url = objects[i]["href"] as? String
                    
                    newContest.objectId = "\(i)"
                    
                    newContest.website = websites.last!
                    
                    if let tmp = objects[i]["resource"] {
                        if let tmp2 = tmp?["name"] as? String {
                            for site in websites {
                                if site.url.containsString(tmp2) {
                                    newContest.website = site
                                    break
                                }
                            }
                        }
                    }
                    
                    contests.append(newContest)
                    
                    defaults.setObject(true, forKey: newContest.website.name + "filtered")
                    
                }
                
                
            } catch {
                print("Can not convert to JSON")
            }
        } else {
            print("No new data found. Check your internet connection")
        }
        updateFilteredContestsArray()
        sender.refresh()
        
    })
    myQuery.resume()
    
}


