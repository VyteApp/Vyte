//
//  LoginViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 4/5/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    let permissions = ["public_profile", "user_friends", "user_about_me", "user_events"]
    
    @IBOutlet var fbLoginView: FBLoginView!
    
    @IBAction func fbLoginButton(sender: AnyObject) {
        NSLog("clicked")
        PFFacebookUtils.logInWithPermissions(self.permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("The user cancelled the Facebook login.")
            } else {
                if user.isNew {
                    //TODO: Save user's info (e.g. name, fbID, profile pic, etc)
                    NSLog("User signed up and logged in through Facebook: \(user)")
                } else {
                    NSLog("User logged in through Facebook: \(user)")
                }
                if !PFFacebookUtils.isLinkedWithUser(user) {
                    PFFacebookUtils.linkUser(user, permissions: self.permissions, { // permissions:nil
                    (succeeded: Bool!, error: NSError!) -> Void in
                    if (succeeded.boolValue) {
                        println("Linked existing user with Facebook.")
                    }
                    })}
                self.loginViewShowingLoggedInUser(self.fbLoginView)
            }

        })
    }

    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        performSegueWithIdentifier("Push", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbLoginView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}