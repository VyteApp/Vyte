//
//  SecondViewController.swift
//  Vyte
//
//  Created by Marcos Alberto Pertierra Arrojo on 3/24/15.
//  Copyright (c) 2015 Vyte. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let user = PFUser.currentUser()
    
    
    func getFacebookEvents() {
        var completionHandler = {
            connection, result, error in
            println("result: \(result)")
            } as FBRequestHandler;
        
        FBRequestConnection.startWithGraphPath("/me/events", completionHandler: completionHandler)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFacebookEvents()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

