//
//  ContestTableViewCell.swift
//  Competitive-Programming-Appp
//
//  Created by ikbal kazar on 18/02/16.
//  Copyright © 2016 harungunaydin. All rights reserved.
//

import UIKit
import EventKit

class ContestTableViewCell: UITableViewCell {
    
    var contest: Contest = Contest()
    var savedEvents = [EKEvent]()
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet weak var contestNameLabel: UILabel!
    @IBOutlet var startDateTimeLabel: UILabel!
    
    @IBAction func addToCalendar(sender: AnyObject) {
        let store = EKEventStore()
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted {
                self.displayAlert("Error", message: "Access to calendar is needed")
                return
            }
            let event = EKEvent(eventStore: store)
            event.title = self.contest.name
            
            //Formats the start date-time
            var dateAsString = self.contest.start
            dateAsString.removeAtIndex(dateAsString.startIndex.advancedBy(10))
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
            event.startDate = dateFormatter.dateFromString(dateAsString)!
            
            //End date = start date + duration
            event.endDate = event.startDate.dateByAddingTimeInterval(self.contest.duration)
            
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.saveEvent(event, span: .ThisEvent, commit: true)
                self.displayAlert("Done", message: "Contest is successfuly added to the calendar")
                self.savedEvents.append(event)
                //self.savedEventId = event.eventIdentifier //save event id to access this particular event later
            } catch {
                self.displayAlert("Error", message: "Cannot add the contest to the calendar")
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func FormatForTable(strDate : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date = dateFormatter.dateFromString(strDate)
        dateFormatter.dateFormat = "MM/dd HH:mm"
        return dateFormatter.stringFromDate(date!)
    }
    
    func setContest(selectedContest: Contest) {
        contest = selectedContest
        cellImage.image = contest.getImage()
        contestNameLabel.text = contest.name
        
        startDateTimeLabel.text = FormatForTable(contest.localStart())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}