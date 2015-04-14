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
    
    @IBOutlet weak var myEventsTableView: UITableView!
    
    let sections = ["Hosting","Attending"]
    
    var events : [[Event]] = [[],[],[]]
    
    //var events : [[String]] = [["Hosting1","Hosting2"],["Att1", "Att2", "Att3", "Att4"]]
    
    @IBAction func createEventButton(sender: UIButton) {
        performSegueWithIdentifier("createEventSegue", sender: self)
    }
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myEventsTableView.delegate = self
        myEventsTableView.dataSource = self
        
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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Hosting" {
            let event = sender as! Event
            let vc = segue.destinationViewController as! HostEventViewController
            vc.eventName.text = event.name
            vc.eventTime.text = event.start_time.description
            //TODO: convert location coordinates to address
            //vc.eventLocation.text = event!.location to address
            vc.eventDescription.text == ""
            vc.invitees = []

        } else if segue.identifier == "Attending" {
            let event = sender as! Event
            let vc = segue.destinationViewController as! GuestEventViewController
            vc.eventName.text = event.name
            vc.eventTime.text = event.start_time.description
            //TODO: convert location coordinates to address
            //vc.eventLocation.text = event!.location to address
            vc.eventDescription.text == ""
            vc.invitees = []
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