//
//  CheckInList.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 5/12/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation

class CheckInListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet var guestsTableView: UITableView!
    
    let sections = ["Checked-in", "Nearby (1 mile)"]
    
    let customCellIdentifier = "textCell"
    
    var event: PFObject!
    
    var guestList: [[PFUser]] = [[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let checkedIn: [String] = event["CheckedIn"] as! [String]
        guestList[0] = PFUser.query()!.whereKey("objectId", containedIn: checkedIn).findObjects() as! [PFUser]
        var query = PFUser.query()!.whereKey("Location", nearGeoPoint:event["Location"] as! PFGeoPoint, withinMiles: 1.0)
        query.limit = 20
        guestList[1] = query.findObjects() as! [PFUser]
        guestsTableView.reloadData()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(customCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = guestList[indexPath.section][indexPath.row].username
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
}