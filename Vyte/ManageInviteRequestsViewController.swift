//
//  ApproveInviteRequestsViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 5/5/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation

class ManageInviteRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet var requestsTableView: UITableView!
    
    let customCellIdentifier = "checkMarkCell"
    
    var event: PFObject!
    
    var requesting: [PFUser]!
    
    var invited: [PFUser]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        println("cancel")
    }
    
    @IBAction func done(sender: AnyObject) {
        let vc = self.presentingViewController as! HostEventViewController
        vc.invitees[2].extend(invited)
        let invitedObjectIds : [String] = invited.map({$0.objectId!})
        event.addObjectsFromArray(invitedObjectIds, forKey: "Invites")
        event.removeObjectsInArray(invitedObjectIds, forKey: "RequestingInvite")
        event.save()
        //TODO: Send invite notification to users
        let eventName = event.objectForKey("Name") as! String
        let host = PFUser.currentUser()!.username
        let pushQuery = PFInstallation.query()!
        pushQuery.whereKey("user", containedIn: invited)
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setMessage("\(host) invited you to the event \(eventName)")
        push.sendPushInBackgroundWithBlock(nil)
        self.dismissViewControllerAnimated(false, completion: nil)
        println("done")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return requesting.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(customCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let user = requesting[indexPath.row] as PFUser
        cell.textLabel?.text = user.objectForKey("username") as? String
        
        for (var i=0;i<invited.count;i++){
            if invited[i].objectId == user.objectId{
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                break
            }
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let user = requesting[indexPath.row] as PFUser
        
        var index: Int!
        for (var i=0;i<invited.count;i++){
            if invited[i].objectId == user.objectId{
                index = i
                break
            }
        }
        if index == nil {
            invited.append(user)
        } else {
            invited.removeAtIndex(index)
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    
}