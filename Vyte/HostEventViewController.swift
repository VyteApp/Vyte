//
//  HostEventViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 4/12/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation
import MapKit

class HostEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var eventName: UILabel! = UILabel()
    
    @IBOutlet var eventTime: UILabel! = UILabel()
    
    @IBOutlet var eventLocation: UILabel! = UILabel()
    
    @IBOutlet var eventDescription: UILabel! = UILabel()
        
    @IBOutlet var attendees: UITableView!
    
    @IBOutlet var manageInviteRequestsButton: UIButton!
    
    @IBOutlet var checkInButton: UIButton!
    
    var event : PFObject!
    
    let sections = ["Attending", "Not Attending", "Invited"]
    
    var invitees : [[PFUser]] = [[],[],[]]
    
    let textCellIdentifier = "TextCell"
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invitees[0] = PFUser.query()!.whereKey("objectId", containedIn: event["Attending"] as![String]).findObjects() as! [PFUser]
        invitees[1] = PFUser.query()!.whereKey("objectId", containedIn: event["NotAttending"] as![String]).findObjects() as! [PFUser]
        invitees[2] = PFUser.query()!.whereKey("objectId", containedIn: event["Invites"] as![String]).findObjects() as! [PFUser]
        attendees.delegate = self
        attendees.dataSource = self
        eventName.text = event.objectForKey("Name") as? String
        eventTime.text = event.objectForKey("StartTime")!.description
        eventLocation.text = event.objectForKey("Address") as? String
        eventDescription.text = event.objectForKey("Description") as? String
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.attendees.addSubview(refreshControl)
        
        /*for user in invitees[0] {
            let pushQuery = PFInstallation.query()!
            pushQuery.whereKey("user", equalTo: user)
            
            let push = PFPush()
            push.setQuery(pushQuery)
            push.setMessage("You're invited to an event by \(PFUser.currentUser()!.username)")
            push.sendPushInBackgroundWithBlock(nil)
        }*/
    }
    
    func refresh(sender:AnyObject){
        invitees[0] = PFUser.query()!.whereKey("objectId", containedIn: event["Attending"] as![String]).findObjects() as! [PFUser]
        invitees[1] = PFUser.query()!.whereKey("objectId", containedIn: event["NotAttending"] as![String]).findObjects() as! [PFUser]
        invitees[2] = PFUser.query()!.whereKey("objectId", containedIn: event["Invites"] as![String]).findObjects() as! [PFUser]
        attendees.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func viewCheckInList(sender: UIButton){
        performSegueWithIdentifier("checkInList", sender: sender)
    }
    @IBAction func manageInviteRequests(sender: UIButton){
        performSegueWithIdentifier("manageInviteRequests", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "manageInviteRequests"{
            let vc = segue.destinationViewController as! ManageInviteRequestsViewController
            let usersRequestingInvites = event["RequestingInvite"] as! [String]
            vc.event = event
            vc.requesting = PFUser.query()!.whereKey("objectId", containedIn: usersRequestingInvites).findObjects() as! [PFUser]
        } else if segue.identifier == "checkInList"{
            let vc = segue.destinationViewController as! CheckInListViewController
            vc.event = event
        }
    }
    
    @IBAction func Back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
        println("back")
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitees[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = invitees[indexPath.section][indexPath.row].username
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println(invitees[indexPath.section][indexPath.row])
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

}
