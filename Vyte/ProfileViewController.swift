//
//  ProfileViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var profilePic: FBProfilePictureView!
    
    @IBOutlet var profileName: UILabel!
    
    @IBOutlet var myEventsLabel: UILabel!
    
    @IBOutlet weak var myEventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (PFUser.currentUser() != nil){
            profileName.text = PFUser.currentUser().username
            profilePic = FBProfilePictureView.init()
            profilePic.profileID = PFUser.currentUser()["fbId"] as String
            profilePic.pictureCropping = FBProfilePictureCropping.Square
        } else {
            NSLog("Current user is nil but got through log-in???")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}