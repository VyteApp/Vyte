//
//  GuestEventViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 4/12/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation
import MapKit

class GuestEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var eventName: UILabel!
    
    @IBOutlet var eventTime: UILabel!

    @IBOutlet var eventLocation: UILabel!

    @IBOutlet var eventDescription: UILabel!
    
    @IBOutlet var acceptInviteButton: UIButton!
    
    @IBOutlet var declineInviteButton: UIButton!

    @IBOutlet var attendees: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var event: PFObject!
    
    let sections = ["Attending", "Not Attending", "Invited"]
    
    var invitees : [[PFUser]] = [[],[],[]]
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendees.delegate = self
        attendees.dataSource = self
        eventName.text = event.objectForKey("Name") as? String
        eventTime.text = event.objectForKey("StartTime")!.description
        eventLocation.text = event.objectForKey("Address") as? String
        eventDescription.text = event.objectForKey("Description") as? String
        if !contains(invitees[2],PFUser.currentUser()!){
            acceptInviteButton.hidden = true
            declineInviteButton.hidden = true
        }
    }
    
    @IBAction func acceptInvite(sender: UIButton){
        println("Accepted Invite")
        let objectId = PFUser.currentUser()?.objectId
        var invited: [String] = PFUser.currentUser()?.objectForKey("Invited") as! [String]
        var index = find(invited,objectId!)
        invited.removeAtIndex(index!)
        PFUser.currentUser()?.setObject(invited, forKey: "Invited")
        var attending: [String] = PFUser.currentUser()?.objectForKey("Attending") as! [String]
        attending.append(objectId!)
        PFUser.currentUser()?.setObject(attending, forKey: "Attending")
        PFUser.currentUser()?.save()
        
        var eventObj = PFQuery(className: "Event").whereKey("objectId", equalTo: event.objectId!).findObjects()!.first as! PFObject
        invited = eventObj.objectForKey("Invited") as! [String]
        index = find(invited,objectId!)
        invited.removeAtIndex(index!)
        eventObj.setObject(invited, forKey: "Invited")
        attending = eventObj.objectForKey("Attending") as! [String]
        attending.append(objectId!)
        eventObj.setObject(attending, forKey: "Attending")
        eventObj.save()

        
        index = find(invitees[2],PFUser.currentUser()!)
        invitees[2].removeAtIndex(index!)
        invitees[0].append(PFUser.currentUser()!)
        
        acceptInviteButton.hidden = true
        declineInviteButton.hidden = true
        
        attendees.reloadData()
    }
    
    @IBAction func declineInvite(sender: UIButton){
        println("Declined Invite")
        let objectId = PFUser.currentUser()?.objectId
        var invited: [String] = PFUser.currentUser()?.objectForKey("Invited") as! [String]
        var index = find(invited,objectId!)
        invited.removeAtIndex(index!)
        PFUser.currentUser()?.setObject(invited, forKey: "Invited")
        var notAttending: [String] = PFUser.currentUser()?.objectForKey("NotAttending") as! [String]
        notAttending.append(objectId!)
        PFUser.currentUser()?.setObject(notAttending, forKey: "NotAttending")
        PFUser.currentUser()?.save()

        var eventObj = PFQuery(className: "Event").whereKey("objectId", equalTo: event.objectId!).findObjects()!.first as! PFObject
        invited = eventObj.objectForKey("Invited") as! [String]
        index = find(invited,objectId!)
        invited.removeAtIndex(index!)
        eventObj.setObject(invited, forKey: "Invited")
        notAttending = eventObj.objectForKey("NotAttending") as! [String]
        notAttending.append(objectId!)
        eventObj.setObject(notAttending, forKey: "NotAttending")
        eventObj.save()
        
        
        index = find(invitees[2],PFUser.currentUser()!)
        invitees[2].removeAtIndex(index!)
        invitees[1].append(PFUser.currentUser()!)
        
        acceptInviteButton.hidden = true
        declineInviteButton.hidden = true
        
        attendees.reloadData()
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
        println("back")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
