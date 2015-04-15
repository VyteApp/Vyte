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
    
    var events : [[Event]] = [[],[]]
    
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
        let hostingEvents = (PFQuery(className: "Event").whereKey("Host", equalTo: host).findObjects())!
        var hostingEvent : Event
        for obj in hostingEvents{
            hostingEvent = Event(host: PFUser.currentUser()!, name: obj["Name"] as! String, description: obj["Description"] as! String, address: obj["Address"] as! String, location: obj["Location"] as! PFGeoPoint, start_time: obj["StartTime"] as! NSDate)
            events[0].append(hostingEvent)
        }
        let attendingEventIDs = PFUser.currentUser()?.objectForKey("AttendingEvents") as! [String]
        let attendingEvents = (PFQuery(className: "Event").whereKey("objectId", containedIn: attendingEventIDs).findObjects())!
        var attendingEvent : Event
        for obj in attendingEvents{
            attendingEvent = Event(name: obj["Name"] as! String, description: obj["Description"] as! String, address: obj["Address"] as! String, location: obj["Location"] as! PFGeoPoint, start_time: obj["StartTime"] as! NSDate)
            events[1].append(attendingEvent)
        }
        myEventsTableView.delegate = self
        myEventsTableView.dataSource = self
    
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Hosting" {
            let event = sender as! Event
            let vc = segue.destinationViewController as! HostEventViewController
            vc.eName = event.name
            vc.eTime = event.start_time.description
            vc.eLocation = event.location.description
            vc.eDescription = event.description
            vc.invitees = [event.getAttendingUsers().map({$0.username!}),[],[]]

        } else if segue.identifier == "Attending" {
            let event = sender as! Event
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.eName = event.name
            vc.eTime = event.start_time.description
            vc.eLocation = event.location.description
            vc.eDescription = event.description
            vc.invitees = [event.getAttendingUsers().map({$0.username!}),[],[]]
            println(vc.invitees)
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
        
        cell.textLabel?.text = events[indexPath.section][indexPath.row].name
        
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