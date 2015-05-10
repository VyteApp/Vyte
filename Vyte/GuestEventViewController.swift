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
    
    @IBOutlet var requestInviteButton: UIButton!
    
    @IBOutlet var declineInviteButton: UIButton!

    @IBOutlet var attendees: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var event: PFObject!
    
    let sections = ["Attending", "Not Attending", "Invited"]
    
    var invitees : [[PFUser]] = [[],[],[]]
    
    var invitationIndex : Int!
    
    let textCellIdentifier = "TextCell"
    
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
        let acceptedInvite = !invitees[0].filter({(e: PFUser) in e.objectId! == PFUser.currentUser()!.objectId!}).isEmpty
        let rejectedInvite = !invitees[1].filter({(e: PFUser) in e.objectId! == PFUser.currentUser()!.objectId!}).isEmpty
        let requestedInvite = contains(event["RequestingInvite"] as! [String],PFUser.currentUser()!.objectId!)
        if acceptedInvite || rejectedInvite || requestedInvite{
            acceptInviteButton.hidden = true
            declineInviteButton.hidden = true
            requestInviteButton.hidden = true
        }else {
            for (var i=0;i<invitees[2].count;i++){
                if invitees[2][i].objectId == PFUser.currentUser()!.objectId{
                    acceptInviteButton.hidden = false
                    declineInviteButton.hidden = false
                    requestInviteButton.hidden = true
                    invitationIndex = i
                    break
                }
            }
            if invitationIndex == nil{
                acceptInviteButton.hidden = true
                declineInviteButton.hidden = true
                requestInviteButton.hidden = false
            }
        }
    }
    
    @IBAction func acceptInvite(sender: UIButton){
        println("Accepted Invite")
        var objectId = event.objectId
        PFUser.currentUser()?.removeObject(objectId!, forKey: "Invites")
        PFUser.currentUser()?.addObject(objectId!, forKey: "Attending")
        PFUser.currentUser()?.save()
        
        objectId = PFUser.currentUser()?.objectId
        event.removeObject(objectId!, forKey: "Invites")
        event.addObject(objectId!, forKey: "Attending")
        event.save()

        invitees[2].removeAtIndex(invitationIndex)
        invitees[0].append(PFUser.currentUser()!)
        
        acceptInviteButton.hidden = true
        declineInviteButton.hidden = true
        
        attendees.reloadData()
    }
    
    @IBAction func requestInvite(sender: UIButton){
        println("Requested Invite")
        let objectId = PFUser.currentUser()?.objectId
        event.addObject(objectId!, forKey: "RequestingInvite")
        event.save()
    
        requestInviteButton.hidden = true
        
    }
    
    @IBAction func declineInvite(sender: UIButton){
        println("Declined Invite")
        var objectId = event.objectId
        PFUser.currentUser()?.removeObject(objectId!, forKey: "Invites")
        PFUser.currentUser()?.addObject(objectId!, forKey: "NotAttending")
        PFUser.currentUser()?.save()
        
        objectId = PFUser.currentUser()?.objectId
        event.removeObject(objectId!, forKey: "Invites")
        event.addObject(objectId!, forKey: "NotAttending")
        event.save()
        
        invitees[2].removeAtIndex(invitationIndex)
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
