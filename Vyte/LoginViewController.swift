//
//  LoginViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 4/5/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController { //, FBLoginViewDelegate {
    
    let permissions = ["public_profile", "user_friends"]
    
    //let fbLoginView = FBLoginView()
    
    @IBOutlet var loginButton : UIButton!
    
    @IBAction func loginButtonTapped(sender: UIButton){
        PFFacebookUtils.logInWithPermissions(self.permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user == nil {
                println("The user cancelled the Facebook login.")
            } else {
                // Associate the device with a user
                let installation = PFInstallation.currentInstallation()
                installation["user"] = user
                installation.saveInBackgroundWithBlock(nil)
                if user!.isNew {
                    if !PFFacebookUtils.isLinkedWithUser(user!) {
                        PFFacebookUtils.linkUser(user!, permissions: self.permissions, block: {
                            (succeeded: Bool, error: NSError?) -> Void in
                            if (succeeded.boolValue) {
                                // Associate the device with a user
                                //let installation = PFInstallation.currentInstallation()
                                //installation["user"] = PFUser.currentUser()
                                //installation.saveInBackgroundWithBlock(nil)
                                println("Linked existing user with Facebook.")
                            }
                        })
                    }
                    if let session = PFFacebookUtils.session() {
                        if session.isOpen {
                            FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                                if error != nil {
                                    println(error.description)
                                } else {
                                    //TODO: Save profile pic?
                                    user!.username = result.name
                                    user!.setValue(result.objectID, forKey: "fbId")
                                    println("User signed up and logged in through Facebook: \(user)")
                                }
                            })
                        }
                    }
                    /*
                    PFGeoPoint.geoPointForCurrentLocationInBackground {
                        (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                        if error == nil {
                            user!.setValue(geoPoint!, forKey: "LastLocation")
                        }else{
                            user!.setValue(PFGeoPoint(), forKey: "LastLocation")
                        }
                        user!.setValue([], forKey: "Invites")
                        user!.setValue([], forKey: "Attending")
                        user!.setValue([], forKey: "NotAttending")
                        user!.save()
                    }
                    */
                    user!.setValue(PFGeoPoint(), forKey: "LastLocation")
                    user!.setValue([], forKey: "Invites")
                    user!.setValue([], forKey: "Attending")
                    user!.setValue([], forKey: "NotAttending")
                    user!.save()

                } else {
                    println("User logged in through Facebook: \(user)")
                }
                //if self.navigationController?.visibleViewController is LoginViewController {
                self.performSegueWithIdentifier("LoggedIn", sender: self)
                //}
            }
            
        })
    }
    
    /*
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("LOGINVIEWSHOWINGLOGGEDINUSER")
        //self.saveUserNameAndFbId()
        //if self.navigationController?.visibleViewController is LoginViewController {
            performSegueWithIdentifier("LoggedIn", sender: self)
        //}
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  fbLoginView.delegate = self
        println("CurrentUser",PFUser.currentUser())
        if PFUser.currentUser() != nil && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!){
            performSegueWithIdentifier("LoggedIn", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}