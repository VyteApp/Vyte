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
    
    var event : Event!
    
    let sections = ["Attending", "Not Attending", "Invited"]
    
    var invitees : [[String]] = [["Alex", "Bob"],["Carol"], ["Denise"]]
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendees.delegate = self
        attendees.dataSource = self
        eventName.text = event.name
        eventTime.text = event.start_time.description
        eventLocation.text = event.address
        eventDescription.text = event.description
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
        
        cell.textLabel?.text = invitees[indexPath.section][indexPath.row]
        
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
