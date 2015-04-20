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
    
    var events : [[PFObject]] = [[],[],[]]

    let textCellIdentifier = "TextCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNearbyEvents()
        nearbyEventsTableView.delegate = self
        nearbyEventsTableView.dataSource = self
    }
    
    func loadNearbyEvents(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location : PFGeoPoint = PFGeoPoint(location: appDelegate.locationManager?.location)
        var query = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 1.0)
        events[0] = query.findObjects() as! [PFObject]
        query = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 5.0)
        events[1] = query.findObjects()! as! [PFObject]
        query = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 10.0)
        events[2] = query.findObjects()! as! [PFObject]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewEventFromList" {
            let event = sender as! PFObject
            if (event["Host"] as! String) == PFUser.currentUser()?.objectId{
                let vc = segue.destinationViewController as! HostEventViewController
                vc.event = event
                vc.invitees[0] = PFUser.query()!.whereKey("objectId", containedIn: event["Attending"] as![String]).findObjects() as! [PFUser]
                vc.invitees[1] = PFUser.query()!.whereKey("objectId", containedIn: event["NotAttending"] as![String]).findObjects() as! [PFUser]
                vc.invitees[2] = PFUser.query()!.whereKey("objectId", containedIn: event["Invites"] as![String]).findObjects() as! [PFUser]
            }else{
                let vc = segue.destinationViewController as! GuestEventViewController
                vc.event = event
                vc.invitees[0] = PFUser.query()!.whereKey("objectId", containedIn: event["Attending"] as![String]).findObjects() as! [PFUser]
                vc.invitees[1] = PFUser.query()!.whereKey("objectId", containedIn: event["NotAttending"] as![String]).findObjects() as! [PFUser]
                vc.invitees[2] = PFUser.query()!.whereKey("objectId", containedIn: event["Invites"] as![String]).findObjects() as! [PFUser]
            }
        }
    }

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
        
        cell.textLabel?.text = events[indexPath.section][indexPath.row].objectForKey("Name") as? String

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

