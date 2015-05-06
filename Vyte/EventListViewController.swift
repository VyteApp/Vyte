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
        nearbyEventsTableView.delegate = self
        nearbyEventsTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        loadEventData()
    }
    
    func loadEventData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location : PFGeoPoint = PFGeoPoint(location: appDelegate.locationManager?.location)
        let query1 = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 1.0)
        query1.findObjectsInBackgroundWithBlock({(results, error) -> Void in
            if error == nil {
                self.events[0] = results as! [PFObject]
                self.nearbyEventsTableView.reloadData()
            }
        })
        //events[0] = query.findObjects() as! [PFObject]
        let query2 = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 5.0)
        //events[1] = query.findObjects()! as! [PFObject]
        query2.findObjectsInBackgroundWithBlock({(results, error) -> Void in
            if error == nil {
                self.events[1] = results as! [PFObject]
                self.nearbyEventsTableView.reloadData()
            }
        })
        let query3 = PFQuery(className: "Event").whereKey("Location", nearGeoPoint: location, withinMiles: 10.0)
        //events[2] = query.findObjects()! as! [PFObject]
        query3.findObjectsInBackgroundWithBlock({(results, error) -> Void in
            if error == nil {
                self.events[2] = results as! [PFObject]
                self.nearbyEventsTableView.reloadData()
            }
        })
        //nearbyEventsTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewGuestEventFromList" {
            let event = sender as! PFObject
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.event = event
        } else if segue.identifier == "viewHostEventFromList"{
            let event = sender as! PFObject
            let vc = segue.destinationViewController as! HostEventViewController
            vc.event = event
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
        let event = events[indexPath.section][indexPath.row]
        if (event["Host"] as! String) == PFUser.currentUser()?.objectId{
            performSegueWithIdentifier("viewHostEventFromList", sender: event)
        }else{
            performSegueWithIdentifier("viewGuestEventFromList", sender: event)
        }

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

}

