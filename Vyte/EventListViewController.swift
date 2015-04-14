//
//  EventListViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit
import MapKit

class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var nearbyEventsLabel : UILabel!
    
    @IBOutlet var nearbyEventsTableView : UITableView!
    
    let sections = ["Within 1 mile", "Within 5 miles", "Within 10 miles"]
    
    var events: [[String]] = []
    
    let user = PFUser.currentUser()
    
    let textCellIdentifier = "TextCell"
    
    func getFacebookEvents() {
        var completionHandler = {
            connection, result, error in
            println("result: \(result)")
            } as FBRequestHandler;
        
        if let session = PFFacebookUtils.session() {
            //TODO: Get access to "user_events" permission
            println("permissions: \(session.permissions)")
            var token = session.accessTokenData.accessToken
            if session.isOpen {
                FBRequestConnection.startWithGraphPath("me/events", completionHandler: completionHandler)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyEventsTableView.delegate = self
        nearbyEventsTableView.dataSource = self
        //getFacebookEvents()

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
        
        cell.textLabel?.text = events[indexPath.section][indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println(events[indexPath.section][indexPath.row])
        //performSegueWithIdentifier(enter identifier, sender: self)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

}

