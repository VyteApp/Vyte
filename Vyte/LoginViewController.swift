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
                    })
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
                                }
                            }
                        })
                    }
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
            println("FB session:",PFFacebookUtils.session())
            performSegueWithIdentifier("LoggedIn", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}