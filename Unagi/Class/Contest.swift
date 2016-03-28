//
//  Contest.swift
//  Competitive-Programming-Appp
//
//  Created by Harun Gunaydin on 2/14/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import CoreData

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

func updateFilteredContestsArray() {
    
    filteredContests.removeAll()
    
    for contest in contests {
        
        if contest.website == nil {
            print("There is a problem here in Contest.swift")
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey(contest.website.name + "filtered") as! Bool {
            filteredContests.append(contest)
        }
    }
    
}

func initializeContestsArrayUsingContestEntity() {
    
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext!
    
    let request = NSFetchRequest(entityName: "Contest")
    
    do {
        if let objects = try context.executeFetchRequest(request) as? [NSManagedObject] {
            
            for object in objects {
                
                let newContest = Contest()
                newContest.name = object.valueForKey("name") as! String
                newContest.start = object.valueForKey("start") as! String
                newContest.end = object.valueForKey("end") as! String
                newContest.duration = object.valueForKey("duration") as? Double
                newContest.url = object.valueForKey("url") as? String
                newContest.website = object.valueForKey("website") as! Website
                
                contests.append(newContest)
                
            }
            
            updateFilteredContestsArray()
            
        }
    } catch {
        print("Could not execute Fetch Request - Contest Entity")
    }
    
    print("Contests Array size => \(contests.count)")
    
}

func updateContestEntityUsingClistBy() {
    
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
                
                print("Json convertion is successful")
                
                if clearEntity("Problem") == false {
                    print("Could not delete objects in Contest Entity. Will not procede further")
                }
                
                for i in 0 ..< objects.count {
                    
                    let newContest = Contest()
                    
                    newContest.name = objects[i]["event"] as? String
                    
                    if let tmp = objects[i]["start"] as? String {
                        newContest.start = tmp
                    }
                    if let tmp = objects[i]["end"] as? String {
                        newContest.end = tmp
                    }
                    if let tmp = objects[i]["duration"] as? Double {
                        newContest.duration = tmp
                    }
                    if let tmp = objects[i]["href"] as? String {
                        newContest.url = tmp
                    }
                    
                    if let tmp = objects[i]["resource"] {
                        if let tmp2 = tmp?["name"] as? String {
                            
                            for site in websites {
                                if site.name.containsString(tmp2) {
                                    newContest.website = site
                                    break
                                }
                            }
                        }
                    }
                    
                    newContest.objectId = "\(i)"
                    
                    print( saveToEntity("Contest", object: newContest) )
                    
                }
                
            } catch {
                print("Can not convert to JSON")
            }
        } else {
            print("No new data found. Check your internet connection")
        }
        
        initializeContestsArrayUsingContestEntity()
        
    })
    myQuery.resume()
    
}
