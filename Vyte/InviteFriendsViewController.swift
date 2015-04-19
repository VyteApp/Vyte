//
//  InviteFriendsViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 4/18/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation

class InviteFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet var friendsTableView: UITableView!

    let customCellIdentifier = "checkMarkCell"
    
    var friends: [PFUser]!
    
    var invited: [PFUser]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*FBRequestConnection.startForMyFriendsWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
            if error == nil {
                var friendObjects = result["data"] as [NSDictionary]
                for friendObject in friendObjects {
                    println(friendObject["id"] as NSString)
                }
                println("\(friendObjects.count)")
            } else {
                println("Error requesting friends list form facebook")
                println("\(error)")
            }
        })*/
        let me: String = (PFUser.currentUser()?.objectId)!
        //TODO: Not show every user
        friends = PFUser.query()!.whereKey("objectId", notEqualTo: me).findObjects() as! [PFUser]
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        println("cancel")
    }
    
    @IBAction func done(sender: AnyObject) {
        /*var invList: [PFUser] = []
        var indexPath : NSIndexPath
        var cell : UITableViewCell
        for(var i=0;i<friends.count;i++){
            indexPath = NSIndexPath(forRow: i, inSection: 0)
            cell = friendsTableView.dequeueReusableCellWithIdentifier(customCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
            if cell.accessoryType == UITableViewCellAccessoryType.Checkmark{
                invList.append(friends[i])
            }
        }
        invited = invList*/
        let vc = self.presentingViewController as! EventCreatorViewController
        vc.invitedFriends = invited
        self.dismissViewControllerAnimated(false, completion: nil)
        println("done")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return friends.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(customCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let user = friends[indexPath.row] as PFUser
        cell.textLabel?.text = user.objectForKey("username") as? String

        if contains(invited,user){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let user = friends[indexPath.row] as PFUser

        if contains(invited,user){
            let index = find(invited,user)
            invited.removeAtIndex(index!)
        }else{
            invited.append(user)
        }

        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    

}