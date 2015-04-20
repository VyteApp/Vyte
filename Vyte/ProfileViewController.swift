//
//  ProfileViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var profileName: UILabel!
    
    @IBOutlet var myEventsLabel: UILabel!
    
    @IBOutlet var myEventsTableView: UITableView!
    
    let sections = ["Hosting","Attending"]
    
    var events : [[PFObject]] = [[],[]]
    
    @IBAction func createEventButton(sender: UIButton) {
        performSegueWithIdentifier("createEventSegue", sender: self)
    }
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profileName.text = PFUser.currentUser()!.username
        var fbSession = PFFacebookUtils.session()
        var accessToken = fbSession!.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()){ (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            // Display the image
            let image = UIImage(data: data)
            self.profilePic.contentMode = UIViewContentMode.ScaleAspectFit
            self.profilePic.image = image
        }
        let host: String = profileName.text!
        events[0] = (PFQuery(className: "Event").whereKey("Host", equalTo: host).findObjects())! as! [PFObject]
        let me: PFUser = PFUser.currentUser()!
        let attendingEventIDs = me.objectForKey("Attending") as! [String]
        events[1] = (PFQuery(className: "Event").whereKey("objectId", containedIn: attendingEventIDs).findObjects())! as! [PFObject]
        myEventsTableView.delegate = self
        myEventsTableView.dataSource = self
    
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Hosting" {
            let event = sender as! PFObject
            let vc = segue.destinationViewController as! HostEventViewController
            vc.event = event
            vc.invitees[0] = PFUser.query()!.whereKey("objectId", containedIn: event["Attending"] as![String]).findObjects() as! [PFUser]
            vc.invitees[1] = PFUser.query()!.whereKey("objectId", containedIn: event["NotAttending"] as![String]).findObjects() as! [PFUser]
            vc.invitees[2] = PFUser.query()!.whereKey("objectId", containedIn: event["Invites"] as![String]).findObjects() as! [PFUser]

        } else if segue.identifier == "Attending" {
            let event = sender as! PFObject
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.event = event
            vc.invitees[0] = PFUser.query()!.whereKey("objectId", containedIn: event["Attending"] as![String]).findObjects() as! [PFUser]
            vc.invitees[1] = PFUser.query()!.whereKey("objectId", containedIn: event["NotAttending"] as![String]).findObjects() as! [PFUser]
            vc.invitees[2] = PFUser.query()!.whereKey("objectId", containedIn: event["Invites"] as![String]).findObjects() as! [PFUser]

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
        println(events[indexPath.section][indexPath.row])
        performSegueWithIdentifier(sections[indexPath.section], sender: events[indexPath.section][indexPath.row])
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

}