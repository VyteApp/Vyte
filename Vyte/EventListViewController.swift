//
//  EventListViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit
import CoreLocation

class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var nearbyEventsLabel : UILabel!
    
    @IBOutlet var nearbyEventsTableView : UITableView!
    
    let sections = ["Within 1 mile", "Within 5 miles", "Within 10 miles"]
    
    var events : [[Event]] = [[],[],[]]

    let textCellIdentifier = "TextCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location : PFGeoPoint = PFGeoPoint(location: appDelegate.locationManager?.location)
        var query = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 1.0)
        var results = query.findObjects()!
        for obj in results {
            events[0].append(Event(name: obj["Name"] as! String, description: obj["Description"] as! String, address: obj["Address"] as! String, location: obj["Location"] as! PFGeoPoint, start_time: obj["StartTime"] as! NSDate))
        }
        query = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 5.0)
        results = query.findObjects()!
        for obj in results {
            events[1].append(Event(name: obj["Name"] as! String, description: obj["Description"] as! String, address: obj["Address"] as! String, location: obj["Location"] as! PFGeoPoint, start_time: obj["StartTime"] as! NSDate))
        }
        query = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 10.0)
        results = query.findObjects()!
        for obj in results {
            events[2].append(Event(name: obj["Name"] as! String, description: obj["Description"] as! String, address: obj["Address"] as! String, location: obj["Location"] as! PFGeoPoint, start_time: obj["StartTime"] as! NSDate))
        }
        nearbyEventsTableView.delegate = self
        nearbyEventsTableView.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewEventFromList" {
            let event = sender as! Event
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.event = event
            vc.invitees = [event.getAttendingUsers().map({$0.username!}),[],[]]
        }
    }
    
    /*
    func getFacebookEvents() {
        var completionHandler = {
            connection, result, error in
            println("result: \(result)")
            } as FBRequestHandler;
        
        if let session = PFFacebookUtils.session() {
            //TODO: Get access to "user_events" permission
            println("permissions: \(session.permissions)")
            var token = session.accessTokenData.accessToken
            if session.isOpen {
                FBRequestConnection.startWithGraphPath("me/events", completionHandler: completionHandler)
            }
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = events[indexPath.section][indexPath.row].name

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("viewEventFromList", sender: events[indexPath.section][indexPath.row])
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

}

