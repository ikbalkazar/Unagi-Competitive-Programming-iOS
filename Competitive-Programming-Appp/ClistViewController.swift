//
//  ClistViewController.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 14/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit

class ClistViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var contests = [String]()
    
    func updateTable() {
        print(contests.count)
        for s in contests {
            print(s)
        }
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
                    let objects = jsonRes["objects"]!
                    for var i = 0; i < objects!.count; i++ {
                        if let t1 = objects![i]["event"] {
                            if let t2 = objects![i]["start"] {
                                self.contests.append(String(t1!) + " Start: " + String(t2!))
                            }
                        }
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
        print("here!!")
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = contests[indexPath.row]
        return cell
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
