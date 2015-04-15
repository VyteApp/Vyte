//
//  LoginViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 4/5/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    let permissions = ["public_profile", "user_friends", "user_events"]
    
    @IBOutlet var fbLoginView: FBLoginView!
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        self.saveUserNameAndFbId()
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
    
    func saveUserNameAndFbId() {
        if (PFUser.currentUser() == nil || !PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!)){
            println("login failed")
            login()
            return
        }
        else if let fbId = PFUser.currentUser()?.objectForKey("fbId") as? String{
            if !fbId.isEmpty {
                println("User already has FB ID set.")
                return
            }
        }
        if let session = PFFacebookUtils.session() {
            if session.isOpen {
                NSLog("Session is Open")
                FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                    if error != nil {
                        NSLog(error.description)
                    } else {
                        if (PFUser.currentUser() != nil){
                            //TODO: Save profile pic?
                            NSLog("Username and fbID being set")
                            PFUser.currentUser()!.username = result.name
                            PFUser.currentUser()!.setValue(result.objectID, forKey: "fbId")
                            PFUser.currentUser()!.save()
                        }//else {NSLog("User is nil...")}
                    }
                })
            }
            // else {NSLog("Session is not Open")}
        }// else {NSLog("Session is nil")}
    }
    
    func login() {
        PFFacebookUtils.logInWithPermissions(self.permissions, block: {
(user: PFUser?, error: NSError?) -> Void in
            if user == nil {
                NSLog("The user cancelled the Facebook login.")
            } else {
                if user!.isNew {
                    NSLog("User signed up and logged in through Facebook: \(user)")
                } else {
                    NSLog("User logged in through Facebook: \(user)")
                }
                if !PFFacebookUtils.isLinkedWithUser(user!) {
                    PFFacebookUtils.linkUser(user!, permissions: self.permissions, block: {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if (succeeded.boolValue) {
                        println("Linked existing user with Facebook.")
                    }
                    })}
                self.loginViewShowingLoggedInUser(self.fbLoginView)

            }
            
            })
    }
    
    
    
}