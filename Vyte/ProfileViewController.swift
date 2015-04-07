//
//  ProfileViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var profileName: UILabel!
    
    @IBOutlet var myEventsLabel: UILabel!
    
    @IBOutlet weak var myEventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profileName.text = PFUser.currentUser().username
        var fbSession = PFFacebookUtils.session()
        var accessToken = fbSession.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()){ (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            // Display the image
            let image = UIImage(data: data)
            self.profilePic.contentMode = UIViewContentMode.ScaleAspectFit
            self.profilePic.image = image
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}