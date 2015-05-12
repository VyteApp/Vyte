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
    
   // @IBOutlet var myEventsLabel: UILabel!
    
    @IBOutlet var myEventsTableView: UITableView!
    
    @IBOutlet var createEventButton: UIButton!
    
    let sections = ["Hosting","Attending","Invites"]
    
    var events : [[PFObject]] = [[],[],[]]
    
    @IBAction func createNewEvent(sender: UIButton) {
        performSegueWithIdentifier("createEventSegue", sender: self)
    }
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profileName.adjustsFontSizeToFitWidth = true
        profileName.text = PFUser.currentUser()!.username
        var fbSession = PFFacebookUtils.session()
        var accessToken = fbSession!.accessTokenData.accessToken
        //let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        let url = NSURL(string: "https://graph.facebook.com/me/picture?width=100&height=100&return_ssl_resources=1&access_token="+accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()){ (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            // Display the image
            let image = UIImage(data: data)
            //self.profilePic.contentMode = UIViewContentMode.ScaleAspectFit
            self.profilePic.image = image
            self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
            self.profilePic.clipsToBounds = true
            self.profilePic.layer.borderWidth = 3.0
            self.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        }
        myEventsTableView.delegate = self
        myEventsTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        loadEventData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Hosting" {
            let event = sender as! PFObject
            let vc = segue.destinationViewController as! HostEventViewController
            vc.event = event
        } else if segue.identifier == "Attending" {
            let event = sender as! PFObject
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.event = event
        } 
        
    }
    
    func loadEventData(){
        events[0] = (PFQuery(className: "Event").whereKey("Host", equalTo: PFUser.currentUser()!.objectId!).findObjects())! as! [PFObject]
        let me: PFUser = PFUser.currentUser()!
        let attendingEventIDs = me.objectForKey("Attending") as! [String]
        events[1] = (PFQuery(className: "Event").whereKey("objectId", containedIn: attendingEventIDs).findObjects())! as! [PFObject]
        //let invitedEventIDs = me.objectForKey("Invites") as! [String]
        //events[2] = (PFQuery(className: "Event").whereKey("objectId", containedIn: invitedEventIDs).findObjects())! as! [PFObject]
        events[2] = (PFQuery(className:"Event").whereKey("Invites", containsAllObjectsInArray: [me.objectId!]).findObjects())! as! [PFObject]
        myEventsTableView.reloadData()
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
        if sections[indexPath.section] == "Invites" {
            performSegueWithIdentifier("Attending", sender: events[indexPath.section][indexPath.row])
        }else{
            performSegueWithIdentifier(sections[indexPath.section], sender: events[indexPath.section][indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

}