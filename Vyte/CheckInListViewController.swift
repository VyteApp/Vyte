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
    
    let sections = ["Nearby (1 mile)","Checked-in"]
    
    let customCellIdentifier = "textCell"
    
    var event: PFObject!
    
    var guestList: [[PFUser]] = [[],[]]
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFUser.query()!.whereKey("LastLocation", nearGeoPoint:event["Location"] as! PFGeoPoint, withinMiles: 1.0)
        query.limit = 20
        guestList[0] = query.findObjects() as! [PFUser]
        let checkedIn: [String] = event["CheckedIn"] as! [String]
        guestList[1] = PFUser.query()!.whereKey("objectId", containedIn: checkedIn).findObjects() as! [PFUser]
        guestsTableView.reloadData()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.guestsTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject){
        var query = PFUser.query()!.whereKey("LastLocation", nearGeoPoint:event["Location"] as! PFGeoPoint, withinMiles: 1.0).whereKey("objectId", containedIn:event["Attending"] as! [String]).whereKey("objectId",notContainedIn:event["CheckedIn"] as! [String])
        query.limit = 20
        guestList[0] = query.findObjects() as! [PFUser]
        let checkedIn: [String] = event["CheckedIn"] as! [String]
        guestList[1] = PFUser.query()!.whereKey("objectId", containedIn: checkedIn).findObjects() as! [PFUser]
        guestsTableView.reloadData()
        self.refreshControl.endRefreshing()
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
        
        let user = guestList[indexPath.section][indexPath.row]
        
        if indexPath.section == 0{
            event.addObject(user.objectId!, forKey: "CheckedIn")
            event.save()
            guestList[0].removeAtIndex(indexPath.row)
            guestList[1].append(user)
            guestsTableView.reloadData()
        }
    }
    
    
}