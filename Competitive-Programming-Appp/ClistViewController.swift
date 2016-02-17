//
//  ClistViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 14/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//
//  Modified: Harun Gunaydin Feb. 2016.

import UIKit

var contests = [ Contest ]()
var selectedContest: Contest!

class ClistViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    func updateTable() {
        //print(contests.count)
        //for s in contests {
        //    print(s.website)
        //}
        tableView.reloadData()
    }
    
    func data_request(){
        
        let url:NSURL = NSURL(string: "https://clist.by/api/v1/json/contest/?username=ikbalkazar&api_key=b66864909a08b2ddf96b258a146bd15c2db6a469")!
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let urlSession = NSURLSession(configuration: config)
        
        let myQuery = urlSession.dataTaskWithURL(url, completionHandler: {
            data, response, error -> Void in
            if let content = data {
                do {
                    let jsonRes = try NSJSONSerialization.JSONObjectWithData(content, options: NSJSONReadingOptions.MutableContainers)
                    let objects = jsonRes["objects"]!!
                    print(jsonRes)
                    for var i = 0; i < objects.count; i++
                    {
                        var event = "No information on event name"
                        var start = "No information on start time"
                        var end   = "No information on end time"
                        var dur   = "No information on duration"
                        var url   = "No information on url"
                        if let tmp = objects[i]["event"] as? String {
                            event = tmp
                        }
                        if let tmp = objects[i]["start"] as? String {
                            start = tmp
                        }
                        if let tmp = objects[i]["end"] as? String {
                            end = tmp
                        }
                        if let tmp = objects[i]["duration"] as? String {
                            dur = tmp
                        }
                        if let tmp = objects[i]["href"] as? String {
                            url = tmp
                        }
                        
                        let newContest = Contest(event: event, start: start, end: end, duration: dur, url: url)
                        
                        contests.append(newContest)
                    }
                    
                    self.updateTable()
                } catch {
                    print("Could not convert to Json")
                }
            } else {
                print("No Data Found!")
            }
        })
        myQuery.resume()
        //print("here!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        data_request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contests.count
    }
    
    func colorForContest(contest: String ) -> UIColor {
        
        // Label contests by their names and return appropriate color
        
        switch(contest)
        {
            case "Codeforces": return UIColor.blueColor()
            case "Codechef"  : return UIColor.brownColor()
            case "Topcoder"  : return UIColor.redColor()
            case "Hackerrank": return UIColor.greenColor()
            case "ACM" :       return UIColor.yellowColor()
            case "IOI" :       return UIColor.purpleColor()
            default:           return UIColor.grayColor()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = contests[indexPath.row].event
        cell.textLabel?.textAlignment = .Center
        cell.backgroundColor = colorForContest(contests[indexPath.row].website)
        return cell
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        selectedContest = contests[indexPath.row]
        performSegueWithIdentifier("Contest_Content", sender: self)
        
        return indexPath
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
