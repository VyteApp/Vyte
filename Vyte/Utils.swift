//
//  Utils.swift
//  Vyte
//
//  Created by Matthew Miklasevich on 4/5/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import Foundation

class Utils {
    
//    class func notLoggedIn() -> Bool {
//        let user = PFUser.currentUser()
//        // here I assume that a user must be linked to Facebook
//        return user == nil || !PFFacebookUtils.isLinkedWithUser(user)
//    }
//    class func loggedIn() -> Bool {
//        return !notLoggedIn()
//    }
//    
//    
//    class func logInWithFacebook() {
//        PFFacebookUtils.logInWithPermissions(["public_profile", "user_friends"]) {
//            (user: PFUser!, error: NSError!) -> Void in
//            if user == nil {
//                NSLog("The user cancelled the Facebook login (user is nil)")
//            } else {
//                NSLog("The user successfully logged in with Facebook (user is NOT nil)")
//                // HERE I SET AN ACL TO THE INSTALLATION
//                if let installation = PFInstallation.currentInstallation() {
//                    let acl = PFACL(user: PFUser.currentUser()) // Only user can write
//                    acl.setPublicReadAccess(true) // Everybody can read
//                    acl.setWriteAccess(true, forRoleWithName: "Admin") // Also Admins can write
//                    installation.ACL = acl
//                    //installation.saveEventually()
//                }
//                // THEN I GET THE USERNAME AND fbId
//                Utils.obtainUserNameAndFbId()
//            }
//        }
//    }
//    
//    
//    class func obtainUserNameAndFbId() {
//        if notLoggedIn() {
//            return
//        }
//        let user = PFUser.currentUser() // Won't be nil because is logged in
//        // RETURN IF WE ALREADY HAVE A USERNAME AND FBID (note that we check the fbId because Parse automatically fills in the username with random numbers)
//        if let fbId = user["fbId"] as? String {
//            if !fbId.isEmpty {
//                println("we already have a username and fbId -> return")
//                return
//            }
//        }
//        // REQUEST TO FACEBOOK
//        println("performing request to FB for username and IDF...")
//        if let session = PFFacebookUtils.session() {
//            if session.isOpen {
//                println("session is open")
//                FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
//                    println("done me request")
//                    if error != nil {
//                        println("facebook me request - error is not nil :(")
//                    } else {
//                        println("facebook me request - error is nil :)")
//                        println(result)
//                        // You have 2 ways to access the result:
//                        // 1)
//                        println(result["name"])
//                        println(result["id"])
//                        // 2)
//                        println(result.name)
//                        println(result.objectID)
//                        // Save to Parse:
//                        PFUser.currentUser().username = result.name
//                        PFUser.currentUser().setValue(result.objectID, forKey: "fbId")
//                        //PFUser.currentUser().saveEventually() // Always use saveEventually if you want to be sure that the save will succeed
//                    }
//                })
//            }
//        }
//    }
    
}
