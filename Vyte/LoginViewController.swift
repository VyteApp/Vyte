//
//  LoginViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 4/5/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {

    let permissions = ["public_profile"]
    
    @IBAction func fbLoginButton(sender: UIButton) {
        PFFacebookUtils.logInWithPermissions(self.permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook! \(user)")
            } else {
                NSLog("User logged in through Facebook! \(user)")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}